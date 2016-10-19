# MagicForums

A simple discussion board created by Low Yeong Yih during Magic's Full Stack Development Bootcamp.

Features of the forum includes:

* `User` models with different roles (normal user/admin/moderator).

* User authorization on different functions.

* User's password reset with email.

* `Topic`, `Post`, `Comment` models suitably nested.

* Able to upload image on all models.

* `Vote` added to `Comment` for like/dislike function.

* AJAX done for create/edit function.

* Action Cable done for create/edit/like/dislike function for `Comment`.

* Pretty url done for `Topic` and `Post` using friendly_id.

Test built for this projetct:

* RSpec for unit and feature testing.

* Factory girls used for database records.
