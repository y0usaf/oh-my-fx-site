# Third-party notices

This repository is licensed under AGPL-3.0, but it distributes the following
components from the Apache-2.0 project [vercel-labs/fx](https://github.com/vercel-labs/fx)
(a coding agent harness written in Zig). Those components remain under the
Apache License 2.0, with a copy in [site/Apache-2.0.txt](site/Apache-2.0.txt):

- `site/fx-term.wasm` — the fx interactive-terminal WebAssembly build
- `site/fx-sdk.js` — the fx WebAssembly SDK host layer
- `site/browser.js` — the fx browser entry point

The oh-my-fx fork of vercel-labs/fx carries the small gateway-routing patch
used by the site; the fork lives at [y0usaf/oh-my-fx](https://github.com/y0usaf/oh-my-fx)
(Apache-2.0).
