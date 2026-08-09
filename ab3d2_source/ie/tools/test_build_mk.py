import pathlib
import subprocess
import unittest


REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]


def dry_run(*assignments: str) -> str:
    result = subprocess.run(
        ["make", "-n", *assignments, "ie68-jit-progress-test"],
        cwd=REPO_ROOT,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    return result.stdout


class JITProgressTargetTests(unittest.TestCase):
    def test_overridden_runner_does_not_build_sibling_engine(self) -> None:
        output = dry_run("IE_HEADLESS_ENGINE=/opt/ie/bin/ie_headless")
        self.assertNotIn("make -C ../../IntuitionEngine headless", output)
        self.assertIn("/opt/ie/bin/ie_headless", output)

    def test_configured_engine_source_is_built_by_default(self) -> None:
        engine_source = (REPO_ROOT / "../../IntuitionEngine").resolve()
        output = dry_run(f"IE_ENGINE_SOURCE={engine_source}")
        self.assertIn(f"make -C {engine_source} headless", output)
        self.assertIn(f"{engine_source}/bin/ie_headless", output)


if __name__ == "__main__":
    unittest.main()
