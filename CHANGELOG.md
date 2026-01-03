
- - -

## v0.5.0 - 2026-01-03
#### Features
- edition detection from hardcover provider - (3b2086f) - *jfro*
- hardcover metadata support if provided an API key fixes #22 - (841609f) - *jfro*
- import/export functionality - (1654bf7) - *jfro*
#### Bug Fixes
- support using API's media type if present in batch scanner - (18c4bbd) - *jfro*
- adding book via lookup now simpler & ensure we use provider's cover - (5ecf1b6) - *jfro*

- - -

## v0.4.0 - 2026-01-03
#### Features
- booklore external library sync, fixes #20 - (0ca9c79) - *jfro*
- links to sync'd audiobookshelf books - (fb891bb) - *jfro*
#### Bug Fixes
- search clear button not working - fixes #21 - (8f49cdf) - *jfro*
- external library syncing not supporting books having multiple - (a517303) - *jfro*

- - -

## v0.3.1 - 2026-01-03
#### Bug Fixes
- scheduled sync not syncing anymore from previous status fix - (a3ef0f6) - *jfro*

- - -

## v0.3.0 - 2026-01-03
#### Features
- scheduled external sync - (2cfb2d9) - *jfro*
- basic OIDC auth support via assent - (2b97920) - *jfro*
#### Bug Fixes
- close not working on sync flash messages - fixes #4 - (9f5d049) - *jfro*
- more immediate progress for syncing, fixes #7 - (8625434) - *jfro*
- incorrect OIDC configuration location - (dc590e9) - *jfro*
- configure sender email & name - (d89809f) - *jfro*
- ability to configure prod with mailgun or smtp - fixes #2 - (e52c4fa) - *jfro*
- ability for user to confirm if created/logged in with user & pass - (349d4a2) - *jfro*
- don't show or link to registration page if disabled, fixes #9 - (ede36a2) - *jfro*
- dialyzer warnings - (284be3b) - *jfro*

- - -

## v0.2.0 - 2026-01-03
#### Features
- clickable authors to show all books by matching author (tho isn't - (2b25f0b) - *jfro*
- show books in a series if available - (334430a) - *jfro*
- show version in footer, also bump us for next release - (5f97f99) - *jfro*
#### Bug Fixes
- get what little series data we can manage from OpenLibrary - (307fef7) - *jfro*
- series data not coming over from Audiobookshelf - (a3b5734) - *jfro*

- - -

## v0.1.0 - 2026-01-03
#### Features
- docker configuration - (5d688fe) - *jfro*
- account system, non-email option, app settings - (0a4aefa) - *jfro*
- books now have grid & list views with a toggle - (ed23130) - *jfro*
- admin area, external library refresh ability & status - (24d18be) - *jfro*
- search for books now - (8bd22d1) - *jfro*
- pagination of books, also support for future filter/sort/etc - (92a43ea) - *jfro*
- add calibre external library provider - (ba38917) - *jfro*
- image upload support - (6c48e3d) - *jfro*
- openlibrary url on book pages - (978bf4a) - *jfro*
- batch scanner page - (2bf2332) - *jfro*
- add library of congress provider - (371fee3) - *jfro*
- start of physical scanner support - (998bb60) - *jfro*
- audiobookshelf sync - (628211b) - *jfro*
- ability to specify media types of the books you have in your - (da0b1b2) - *jfro*
- ability to add books to a user's collection - (f42cbe8) - *jfro*
- authentication, some formatting as well - (6a885bf) - *jfro*
- extensible API providers, attempt at barcode scanning in JS - (f7f5fdf) - *jfro*
#### Bug Fixes
- dates now ISO strings to allow for just year publication dates, - (c578d56) - *jfro*
- don't use legacy API for OpenLibrary & extract possible formats - (b3f39da) - *jfro*
- better docker volume name/path for any uploads, not just covers - (02a8e37) - *jfro*
- further fixes for docker & uploaded/imported cover path issue - (ef050d3) - *jfro*
- uploads not being served properly - fixes #5 - (238ee6a) - *jfro*
- docker issues, migrations now run on start - (5532459) - *jfro*
- default to user/pass for non-email-sending setups - (5151c2f) - *jfro*
- scanner adding duplicate books - (dca2780) - *jfro*
- handle calibre cover art properly - (b2fb98c) - *jfro*
- book counts when syncing external libraries - (09bd3b4) - *jfro*
- get completion status working for external sync - (528a65c) - *jfro*
- issue found by dialyzer - (e65df52) - *jfro*
- batch scanner button not looking like one - (f178c64) - *jfro*
- try to avoid failing to match because of (Unabridged) and such in - (f7487f1) - *jfro*
- unspecified & ebooks both being used for calibre added books - (ab8f090) - *jfro*
- series numbers incorrect from calibre & incorrect validation - (6c23acf) - *jfro*
- support decimal series numbers - (ad5cc3d) - *jfro*
- improved syncing from ABS, some DRY around ISBNs - (00bed65) - *jfro*
- external sync not using new cover storage - (0e323c7) - *jfro*
- stream external library items instead of fetching them all - (174bedf) - *jfro*
- cleanup unused collection code, ensure we're on collection_item now - (0cb8a99) - *jfro*
- better scanning mode, cleaned up book form - (764783a) - *jfro*
- use both providers for book lookup - (2dca0fe) - *jfro*
- support scanning longer codes, extracting ISBN - (542b03c) - *jfro*
- go back to being a single library/collection shared among the users - (13d6a14) - *jfro*
- bad name for add to collection button - (8ad8f01) - *jfro*
- improved collection book card sizing - (c4fb535) - *jfro*
- ugly buttons - (acfe26b) - *jfro*
- books not being able to be clicked on - (e077b15) - *jfro*
- lack of navbar, now landing/home page too - (10a7a5c) - *jfro*
#### Refactoring
- priority now based on config array for providers - (b6f9684) - *jfro*
