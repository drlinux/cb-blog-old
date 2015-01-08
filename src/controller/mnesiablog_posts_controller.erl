%% -*- coding: utf-8 -*-
%%adasdsad
-module(mnesiablog_posts_controller, [Req]).
-compile(export_all).

list('GET', []) ->
    Posts=boss_db:find(post, []),
    {ok, [{entries, Posts}]}.

listp('POST', []) ->

    [{sb_uploaded_file, FileName, Location, Length, _,_}] = Req:post_files(), 
    Fname = "./priv/static/media/products/" ++ FileName,
    file:copy(Location, Fname),
    file:delete(Location),
    Title = Req:post_param("title"),
    Content = Req:post_param("content"),
    Slug = erl_slug:slugify(Title),
    NewPost = post:new(id,Title,Content,Slug,calendar:local_time(), calendar:local_time()),
    case NewPost:save() of
        {ok, SavedNewPost} ->
            %%{redirect,[{action, "list"}]};
             {output, Fname};
        {error, ErrorList} -> 
            %%{ok, [{errors, ErrorList}, {new_msg, NewPost}]}
            {output, Location}
    end.

