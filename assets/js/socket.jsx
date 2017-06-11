// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"
import React, {Component} from "react"
import ReactDOM from "react-dom"
import {Grid, Feed, Image, Divider, Icon} from "semantic-ui-react"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()
// Now that you are connected, you can join channels with a topic:
const channelConfigs = {
    steem: {channel: "channel:steem_events", baseUrl: "https://steemit.com"},
    golos: {channel: "channel:golos_events", baseUrl: "https://golos.io"}
}

let steemChannel = socket.channel(channelConfigs.steem.channel, {})
let golosChannel = socket.channel(channelConfigs.golos.channel, {})

steemChannel.join()
    .receive("ok", resp => {
        console.log("Joined successfully", resp)
    })
    .receive("error", resp => {
        console.log("Unable to join", resp)
    })

golosChannel.join()
    .receive("ok", resp => {
        console.log("Joined successfully", resp)
    })
    .receive("error", resp => {
        console.log("Unable to join", resp)
    })

let appData = {
    steemEvents: [],
    golosEvents: [],
}

const renderFeed = (comment, chainProp) => {
    if (comment.created === comment.last_update && comment.author !== "" && comment.parent_author === "") {
        console.log(comment)
        appData[chainProp].unshift(comment)
        appData[chainProp] = appData[chainProp].slice(0, 25)
        ReactDOM.render(
            <App data={appData}/>,
            document.getElementById('realtime-demo')
        )
    }
}

golosChannel.on("new_comment", (comment) => {
    renderFeed(comment, "golosEvents")
})

steemChannel.on("new_comment", (comment) => {
    renderFeed(comment, "steemEvents")
})

const feedEvent = (comment, chain) => {
    const defaultImage = (chain) => `/images/default_img_${chain}.jpg`
    const postLink = (comment, chain) => {
        const baseUrls = {steem: "https://steemit.com", golos: "https://golos.io"}
        return baseUrls[chain] + comment.url
    }
    const generateImages = (comment) => {
        const possibleImages = JSON.parse(comment.json_metadata).image
        if (possibleImages) {
            return possibleImages.map((image, n) => <img key={n} src={image}/>)
        } else {
            return []
        }
    }
    return <Feed.Event key={comment.id}>
        <Feed.Label>
        </Feed.Label>
        <Feed.Content>
            <Feed.Summary>
                <a href={postLink(comment, chain)}>{comment.title}</a>
            </Feed.Summary>
            <Feed.Meta>
                <Feed.User>@{comment.author}</Feed.User>
            </Feed.Meta>
            <Feed.Extra images>
                {generateImages(comment)}
            </Feed.Extra>
        </Feed.Content>
        <Divider/>
    </Feed.Event>
}

class App extends React.Component {
    render() {
        return <Grid columns="2" divided>
            <Grid.Column textAlign="center">
                <Image centered size="tiny" src="/images/steem-logo.png"/>
                <Feed size="large">
                    {this.props.data.steemEvents.map(comment => feedEvent(comment, "steem"))}
                </Feed>
            </Grid.Column>
            <Grid.Column >
                <Image centered size="tiny" src="/images/golos-logo.png"/>
                <Feed size="large">
                    {this.props.data.golosEvents.map(comment => feedEvent(comment, "golos"))}
                </Feed>
            </Grid.Column>
        </Grid>
    }
}

export default socket
