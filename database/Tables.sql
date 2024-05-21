CREATE TYPE "user_types" AS ENUM (
  'Librarian',
  'Admin',
  'Reader'
);

CREATE TYPE "book_status_types" AS ENUM (
  'Active',
  'Lost',
  'Damaged'
);

CREATE TYPE "transaction_types" AS ENUM (
  'Check Out',
  'Return'
);

CREATE TABLE "users" (
  "user_id" SERIAL PRIMARY KEY NOT NULL,
  "first_name" VARCHAR(100) NOT NULL,
  "last_name" VARCHAR(100) NOT NULL,
  "username" VARCHAR(100) UNIQUE NOT NULL,
  "password_hash" VARCHAR(255) NOT NULL,
  "user_type" user_types NOT NULL,
  "barcode" VARCHAR(100) UNIQUE
);

CREATE TABLE "authors" (
  "author_id" SERIAL PRIMARY KEY NOT NULL,
  "author_name" VARCHAR(100) NOT NULL
);

CREATE TABLE "books" (
  "book_id" SERIAL PRIMARY KEY NOT NULL,
  "title" VARCHAR(255) NOT NULL,
  "author_id" INT NOT NULL
);

CREATE TABLE "book_copies" (
  "copy_id" SERIAL PRIMARY KEY NOT NULL,
  "book_id" INT NOT NULL,
  "barcode" VARCHAR(100) UNIQUE NOT NULL,
  "available" BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE "book_status" (
  "status_id" SERIAL PRIMARY KEY NOT NULL,
  "copy_id" INT NOT NULL,
  "status" book_status_types NOT NULL,
  "status_date" TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE "transactions" (
  "transaction_id" SERIAL PRIMARY KEY NOT NULL,
  "user_id" INT NOT NULL,
  "copy_id" INT NOT NULL,
  "transaction_type" transaction_types NOT NULL,
  "transaction_date" DATE NOT NULL,
  "due_date" DATE,
  "return_date" DATE
);

CREATE INDEX ON "users" ("username");

CREATE INDEX ON "users" ("barcode");

CREATE INDEX ON "users" ("username");

CREATE INDEX ON "authors" ("author_name");

CREATE INDEX ON "books" ("title");

CREATE INDEX ON "book_copies" ("barcode");

CREATE INDEX ON "book_status" ("status");

CREATE INDEX ON "book_status" ("status", "status_date");

CREATE INDEX ON "transactions" ("user_id", "copy_id");

ALTER TABLE "books" ADD FOREIGN KEY ("author_id") REFERENCES "authors" ("author_id");

ALTER TABLE "book_copies" ADD FOREIGN KEY ("book_id") REFERENCES "books" ("book_id");

ALTER TABLE "book_status" ADD FOREIGN KEY ("copy_id") REFERENCES "book_copies" ("copy_id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "transactions" ADD FOREIGN KEY ("copy_id") REFERENCES "book_copies" ("copy_id");
