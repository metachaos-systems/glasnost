defmodule GlasnostWeb.BasicGraphql do
  use GlasnostWeb.ConnCase, async: true

  test "golos comments", %{conn: conn} do
    conn = post conn, "/graphql", %{"query": ~s/{ comments(blockchain: "golos") {author, permlink} }/}
    assert json_response(conn, 200) === %{"data" => %{"comments" => []}}
  end

  test "steem comments", %{conn: conn} do
    conn = post conn, "/graphql", %{"query": ~s/{ comments(blockchain: "steem") {author, permlink} }/}
    assert json_response(conn, 200) === %{"data" => %{"comments" => []}}
  end

end
