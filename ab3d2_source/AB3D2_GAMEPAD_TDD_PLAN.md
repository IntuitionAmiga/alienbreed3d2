# AB3D2 Gamepad Support TDD Plan

## Goal and scope

Add game-controller support to the Intuition Engine AB3D2 port without
modifying Intuition Engine. The port will consume the existing read-only
gamepad MMIO ABI from its raw M68K programme.

This work is limited to this repository's IE port sources, test wiring, and
diagnostics. It must not change `../../IntuitionEngine`.

## Existing state

Intuition Engine exposes four normalised controller records at
`0xF25C0-0xF25FF`. Each record provides buttons plus signed 16-bit left and
right stick axes. M68K can read the canonical addresses directly.

The AB3D2 IE port has the necessary legacy control entry points, but they do
not yet consume controller state:

- `_ReadJoy1` and `_ReadJoy2` currently only poll the keyboard.
- The IE-specific player-one path defaults to mouse and keyboard control. The
  shipped IE menu exposes key bindings but no control-mode selector, so the
  legacy `Plr1_Joystick_b` mode cannot be selected through the user interface.
- The menu calls `_ReadJoy1`, but its fire-to-select path is disabled for
  `IS_IE` builds.

The implementation must restore the existing AB3D2 joystick-control flow; it
must not create a second gameplay input system.

## Controller contract

Version one uses controller record zero as the active controller. Do not claim
two-controller local play until the existing player-two control semantics have
been traced and separately proven.

Map input into AB3D2's existing logical actions:

| Controller input | AB3D2 action |
|------------------|--------------|
| Left stick Y or D-pad up/down | Forwards/backwards |
| Left stick X | Step left/right |
| Right stick X or D-pad left/right | Turn left/right |
| Right stick Y | Look up/down |
| A | Fire |
| X | Use/open |
| B | Duck toggle |
| Y | Jump |
| LB | Run |
| RB | Next weapon |
| Start | Pause |

Axes are digital in version one. Use a dead zone and hysteresis, with named
constants in the platform layer. A suggested starting point is engagement at
one quarter of full scale and release below three sixteenths of full scale.
The test suite, not a guessed feel, defines the exact thresholds.

Buttons which are edge-driven in existing AB3D2 control code, including use,
duck, next weapon and pause, must retain their one-action-per-press behaviour.
Held movement, look, run and fire inputs remain held actions.

Keyboard and mouse remain enabled. Controller record zero is additive for
player one and feeds the same existing logical-action state as keyboard input;
it must not disable or replace captured relative-mouse behaviour. Disconnecting
the controller must leave both keyboard and mouse paths cleanly usable.

## Test architecture

The production binary reads gamepad MMIO only. The test binary needs a
deterministic source because gamepad registers are read-only and headless IE
deliberately reports no attached pads.

Add an `IE_GAMEPAD_TEST=1` build define and a port-local input seam:

- Production: the gamepad reader loads the documented MMIO words.
- Test build: the same reader loads a guest-RAM shadow snapshot only when an
  explicit test-enable flag is set.
- The test snapshot contains connected state, buttons, and all four axes.
- The seam and its symbols exist only in the test build; no production input
  path may depend on it.

Add `make ie68-gamepad-test`, which builds the test variant and runs
`ie/gamepad_test.ies` against it. The diagnostic writes the shadow snapshots,
runs the regular game input path, and checks exported game and platform state.
Keep the existing keyboard, mouse, menu, save/load, and packaged-game
diagnostics as regression gates.

## TDD sequence

### 1. Establish the red tests

Before implementing controller reads, add failing tests for:

1. An absent pad changes no controller action.
2. Every mapped button produces only its documented logical action.
3. Each stick direction is inactive in the dead zone, engages at the threshold,
   and remains engaged until its release threshold is crossed.
4. Releasing a held input removes its generated held action.
5. Use, duck, next weapon, and pause produce one action per press, do not
   repeat while held, and work again after release and a new press.
6. Disconnecting a pad clears every generated held action and internal edge
   state.
7. The reachable default mouse-and-keyboard mode routes pad input to player
   one without disabling current relative-mouse behaviour.
8. Menu up/down/select work from the gamepad while keyboard, Enter, Space, and
   mouse menu behaviour remain unchanged.

The first run must fail because the current joystick stubs do not read gamepad
state.

### 2. Add the MMIO and test-snapshot reader

In `ie/ie_hires_platform.s`:

1. Define the gamepad status, button and axis addresses.
2. Add a small reader which returns one coherent local snapshot for pad zero.
3. In the test build, select the RAM shadow only when its enable flag is set.
4. Treat a disconnected pad as all buttons released and all axes centred.

Run the first presence, disconnect, and snapshot-layout tests. They should turn
green before mapping any controller action.

### 3. Add a dedicated joystick translator

Implement `_ReadJoy1` as the sole controller-to-AB3D2 translation boundary.
It should:

1. Read the pad-zero snapshot.
2. Apply axis dead-zone and hysteresis state.
3. Translate axes and buttons into the existing AB3D2 logical action keys and
   edge latches.
4. Clear its own generated state on disconnect.

Do not inject controller state through `ie_poll_keyboard`. That function owns
host keyboard queue semantics, including key-release and one-shot behaviour.
The joystick translator owns controller state instead.

Turn the mapping, hysteresis, release, disconnect, and edge-trigger tests
green one at a time.

### 4. Restore reachable player-one dispatch

Keep the current reachable mouse-plus-keyboard player-one flow. Poll
`_ReadJoy1` from the regular IE input cadence so the translator feeds the
established AB3D2 keyboard-action control routine; do not gate production
polling on the unreachable legacy `Plr1_Joystick_b` flag and do not create a
second gameplay movement implementation.

Do not alter player-two dispatch in this change. Add a failing test proving
that pad zero does not unexpectedly mutate player-two state, then turn it
green as part of this step.

### 5. Enable gamepad menu selection

Keep the menu's existing `_ReadJoy1` call. Make its select branch accept the
controller's fire action in an `IS_IE` build, then prove:

- D-pad or left-stick vertical movement changes menu selection once per
  intended press/repeat rule.
- A activates the selected item.
- The existing keyboard and mouse paths still work.

Do not automatically switch the player's control mode merely because a
controller activates a menu item.

### 6. Run regression and real-device acceptance

Automated gates:

1. `make ie68-gamepad-test`.
2. Existing IE build and diagnostic gates relevant to input, menus, gameplay,
   save/load, and packaged assets.
3. `git diff --check`.

Manual real-device acceptance uses a non-headless IE build, because headless
builds intentionally expose no pads:

1. Start with no controller and confirm unchanged keyboard/mouse behaviour.
2. Connect a standard-layout controller and confirm it remains active alongside
   keyboard and mouse.
3. Verify every mapped action in the menu and during a level.
4. Hold and release each edge-triggered action.
5. Disconnect during held movement and fire; confirm motion and fire stop.
6. Reconnect and confirm captured relative mouse input still works.

Record the controller model, host platform, and binary revision alongside the
acceptance result.

## Explicit non-goals

- No Intuition Engine source, ABI, or runtime changes.
- No two-controller local-play claim in version one.
- No analogue trigger support; the ABI exposes triggers as digital buttons.
- No analogue turn/look speed in version one.
- No changes to AB3D2 multiplayer transport.

## Completion criteria

The work is complete only when the deterministic test suite passes, all
existing relevant IE-port regressions remain green, real hardware verifies the
published mapping, disconnect is safe, and the implementation changes only the
AB3D2 repository.
