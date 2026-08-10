import pathlib
import subprocess
import unittest


REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]


def dry_run(*assignments: str, target: str = "ie68-jit-progress-test") -> str:
    result = subprocess.run(
        ["make", "-f", "ie/Makefile", "-n", *assignments, target],
        cwd=REPO_ROOT,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    return result.stdout


class JITProgressTargetTests(unittest.TestCase):
    def test_progress_target_uses_the_overdrive_redux_image(self) -> None:
        output = dry_run("IE_BUILD_HEADLESS=0")
        self.assertIn("IE_OVERDRIVE=1", output)
        self.assertIn("ab3d2_ie68_redux_high_overdrive.ie68", output)
        self.assertNotIn("ie68-redux-high", output)
        self.assertNotIn("ab3d2_ie68_redux_high.ie68", output)

    def test_overdrive_progress_script_uses_its_supported_headless_floor(self) -> None:
        script = (REPO_ROOT / "ie/bin/ab3d2_ie68_guest_progress.ies").read_text()
        self.assertIn("local minimum_guest_ticks_per_second = 5", script)

    def test_overridden_runner_does_not_build_sibling_engine(self) -> None:
        output = dry_run("IE_HEADLESS_ENGINE=/opt/ie/bin/ie_headless")
        self.assertNotIn("make -C ../../IntuitionEngine headless", output)
        self.assertIn("/opt/ie/bin/ie_headless", output)

    def test_configured_engine_source_is_built_by_default(self) -> None:
        engine_source = (REPO_ROOT / "../../IntuitionEngine").resolve()
        output = dry_run(f"IE_ENGINE_SOURCE={engine_source}")
        self.assertIn(f"make -C {engine_source} headless", output)
        self.assertIn(f"{engine_source}/bin/ie_headless", output)

    def test_ie_entry_point_uses_the_generated_source_overlay(self) -> None:
        result = subprocess.run(
            ["make", "-f", "ie/Makefile", "-n", "ie68"],
            cwd=REPO_ROOT,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )
        output = result.stdout
        self.assertIn("prepare_source_overlay.py", output)
        self.assertIn("cd _build/ie-source", output)
        self.assertIn("-Fhunk hires.s", output)
        self.assertIn("ie/platform/ie_hires_platform.s", output)
        self.assertNotIn("-Fhunk ie/hires.s", output)


class GamepadTargetTests(unittest.TestCase):
    def test_automated_target_defaults_to_headless_engine(self) -> None:
        output = dry_run(target="ie68-gamepad-test")
        self.assertIn("../../IntuitionEngine/bin/ie_headless", output)
        self.assertNotIn("../../IntuitionEngine/bin/IntuitionEngine --script-owned-term", output)

    def test_manual_acceptance_target_defaults_to_gui_engine(self) -> None:
        output = dry_run(target="ie68-gamepad-acceptance")
        self.assertIn("../../IntuitionEngine/bin/IntuitionEngine --script-owned-term", output)
        self.assertNotIn("../../IntuitionEngine/bin/ie_headless --script-owned-term", output)

    def test_automated_runner_override_skips_sibling_engine_build(self) -> None:
        output = dry_run(
            "IE_GAMEPAD_ENGINE=/opt/ie/bin/ie_headless",
            target="ie68-gamepad-test",
        )
        self.assertNotIn("make -C ../../IntuitionEngine headless", output)
        self.assertIn("/opt/ie/bin/ie_headless --script-owned-term", output)


class BlitterTargetTests(unittest.TestCase):
    def test_automated_target_builds_test_variant_and_runs_headless(self) -> None:
        output = dry_run(
            "IE_BUILD_HEADLESS=0",
            target="ie68-blitter-test",
        )
        self.assertIn("IE_BLITTER_TEST=1", output)
        self.assertIn("ab3d2_ie68_blitter_test.ie68", output)
        self.assertIn("../../IntuitionEngine/bin/ie_headless --script-owned-term", output)
        self.assertIn("AB3D2_BLITTER PASS", output)

    def test_production_build_rejects_blitter_test_symbols(self) -> None:
        output = dry_run(
            "IE_BUILD_HEADLESS=0",
            target="ie68",
        )
        self.assertIn("production IE map contains blitter test-seam symbols", output)


class VariantInventoryTests(unittest.TestCase):
    def test_all_target_does_not_build_the_retired_standard_redux_image(self) -> None:
        output = dry_run("IE_BUILD_HEADLESS=0", target="ie68-all")
        self.assertIn("ab3d2_ie68_redux_high_overdrive.ie68", output)
        self.assertNotIn("ie68-redux-high", output)
        self.assertNotIn("ab3d2_ie68_redux_high.ie68", output)


if __name__ == "__main__":
    unittest.main()
