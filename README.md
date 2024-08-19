# RestarTest

A Japanese address database, allowing CSV uploads and exposing a JSON API to upload new CSVs and
view the current state of the database.

## Development Notes

- You can run the `./infra/local_db_user.sql` script to create a SQL role that matches the 
  `config/dev.exs` config. An example invocation: `psql -U postgres -f ./infra/local_db_user.sql`
- `mix deps.get, ecto.create, phx.server` should then fetch and compile dependencies, create the
  database, and start the server locally at `localhost:4000`
- From there you can interact with the web frontend via browser or you can treat it as a JSON API

## API Endpoints

The API exposes the following endpoints:

- `GET <host>/api/`, lists the addresses currently in the database
- `DELETE <host>/api/addresses`, clears the database of all address records
- `POST <host>/api/addresses`, allows submitting a file as parameter `file` to upload

All endpoints return an object with either 1 or 2 keys, as follows:

```js
{
    "addresses": [], // the addresses returned from the database
    "result": {
        "status": "", // either "success" or "failure"
        "message": "" // some extra context about the result operation
    } // "result" is only returned by the DELETE and POST endpoints
}
```

## Assumptions

An example of the columns and order expected can be seen in `./test/data/test.csv`.

The CSV parsing fails to parse non-half-width numbers, so keep that in mind if you see missing rows.
