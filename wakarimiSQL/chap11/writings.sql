create table writings (
  book_id   integer references books(id)
, author_id integer references authors(id)
, role      text
, primary   key(book_id, author_id)
);