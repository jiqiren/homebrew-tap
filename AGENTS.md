# AGENTS.md

This is a Homebrew tap (`jiqiren/tap`) hosting formulae for the `jiqiren` org.
Currently the only formula is **cli-toot** (upstream: https://github.com/jiqiren/cli-toot).

## Layout

- `Formula/<name>.rb` — formula definitions. One class per file, class name is the CamelCase of the filename.
- `.github/workflows/` — CI:
  - `tests.yml` — `brew test-bot` on push to `main` and on PRs. Builds bottles on `macos-26`, `ubuntu-26.04`, `ubuntu-26.04-arm`, uploads them as artifacts `bottles_<os>`.
  - `publish.yml` — runs on successful `test-bot` PR completion. Calls `brew pr-pull` to pull bottle artifacts, merge them into the formula, upload to a GitHub release, and push to `main` (which auto-closes the PR). **Do not push to `main` directly for version bumps — open a PR so bottles get built first.**
  - `autobump.yml` — daily `brew bump` to detect new upstream tags and open PRs automatically.

## Releasing a new version of a formula

When a new tag is cut upstream and you need to ship it here (e.g. to fix a brew-blocking bug):

1. **Fetch the new source tarball sha256:**
   ```sh
   curl -sL "https://github.com/jiqiren/<name>/archive/refs/tags/v<VERSION>.tar.gz" | shasum -a 256
   ```
2. **Create a branch** named `<formula>-<VERSION>` (e.g. `cli-toot-1.1.1`).
3. **Edit `Formula/<name>.rb`:**
   - Update `url` to the new `refs/tags/v<VERSION>.tar.gz`.
   - Update `sha256` to the value from step 1.
   - **Delete the entire `bottle do ... end` block.** `brew pr-pull` will regenerate bottles from the test-bot artifacts and re-add the block.
4. **Commit** with a message like `<formula> <VERSION>` (optionally followed by a body explaining the upstream fix). Match the style of existing commits (`git log --oneline`).
5. **Push the branch and open a PR** to `main`. Title: `<formula> <VERSION>`. Body should state what changed upstream and link to the upstream compare, e.g. `https://github.com/jiqiren/<name>/compare/v<prev>...v<new>`.
6. **Wait.** `test-bot` runs on the PR; on success `publish.yml` runs `brew pr-pull`, which attaches bottles, merges, and closes the PR. No manual merge needed.

### Notes
- Bottle `root_url` follows the pattern `https://github.com/jiqiren/homebrew-tap/releases/download/<formula>-<VERSION>`.
- The formula uses `livecheck` with `strategy :github_latest`, so `brew livecheck` reports upstream tags; `autobump.yml` may open PRs automatically for routine bumps. Manual PRs (above) are for urgent fixes where you want to control timing.
- Upstream release should exist as a git tag before you bump the formula here. The tarball URL must resolve.
- `brew audit --strict --new-formula Formula/<name>.rb` is a good local sanity check before pushing.

## Formula conventions (cli-toot)

- Meson + ninja build, `--wrap-mode=nofallback`.
- Depends on `cjson` and `curl`; on Linux also `llvm` (build, for Clang) and `openssl@3`.
- Test block asserts `cli-toot version` output contains the formula `version`.
- License `BSD-3-Clause`.

## Repo conventions

- Default shell in workflows: `bash -xeuo pipefail`.
- Pinned action SHAs are used throughout workflows — preserve pinning when editing.
- Do not commit bottles by hand; the CI pipeline handles it.
- Never push secrets. Bottles are uploaded to GitHub Releases under the tap repo by the `publish.yml` workflow using `secrets.HOMEBREW_GITHUB_API_TOKEN`.
