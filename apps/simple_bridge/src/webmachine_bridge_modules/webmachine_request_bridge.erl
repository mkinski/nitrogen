% Simple Bridge
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (webmachine_request_bridge).
-behaviour (simple_bridge_request).
-include ("simple_bridge.hrl").

-export ([
    init/1,
    request_method/1, 
    path/1, 
    uri/1,
    peer_ip/1, 
    peer_port/1,
    headers/1, 
    cookies/1,
    query_params/1, 
    post_params/1, 
    request_body/1,
    socket/1,
    recv_from_socket/3
]).

init(Req) -> 
    Req.

request_method(Req) -> 
    wrq:method(Req).

path(Req) -> 
    wrq:path(Req).

uri(Req) -> 
    RawPath = wrq:raw_path(Req),
    {_, QueryString, _} = mochiweb_util:urlsplit_path(RawPath),
    QueryString.

peer_ip(_Req) -> 
    throw(unsupported).

peer_port(_Req) -> 
    throw(unsupported).

headers(Req) ->
    Headers = wrq:req_headers(Req),
    mochiweb_headers:to_list(Headers).

cookies(Req) ->
    wrq:req_cookie(Req).

query_params(Req) ->
    Value = wrq:req_qs(Req),
    Value.

post_params(Req) ->
    Body = wrq:req_body(Req),
    Value = mochiweb_util:parse_qs(Body),
    Value.

request_body(Req) ->
    wrq:req_body(Req).

socket(Req) ->
    {Socket, _} = Req:socket(),
    Socket.

recv_from_socket(Length, Timeout, Req) ->
    Socket = socket(Req),
    case gen_tcp:recv(Socket, Length, Timeout) of
        {ok, Data} -> Data;
        _ -> exit(normal)
    end.
