function post
    # 引数を解析（--title または -t）
    argparse 't/title=' -- $argv
    or return 1

    set dir "$HOME/build/github.com/riou0801/riou0801.github.io/src/posts"
    set today (date "+%Y-%m-%d")
    set file "$dir/$today.md"

    # 既存のmarkdownファイルが引数として渡された場合
    if test (count $argv) -gt 0
        set input_file $argv[1]
        # ファイルが存在し、.mdで終わる場合
        if test -f "$input_file"
            and string match -r '\.md$' "$input_file" >/dev/null
            $EDITOR "$input_file"
            return 0
            # 相対パスや絶対パスでない場合、postsディレクトリ内を検索
        else if string match -r '\.md$' "$input_file" >/dev/null
            set full_path "$dir/$input_file"
            if test -f "$full_path"
                $EDITOR "$full_path"
                return 0
            end
        end
        # ファイルが見つからない場合は警告を出して続行
        echo "Warning: File not found: $input_file"
        echo "Creating new post instead..."
    end

    # 引数があるかチェック（タイトルとして使う）
    if test -z "$_flag_title"
        echo "Usage: post --title 'Your blog post title' [existing_file.md]"
        echo "   or: post existing_file.md"
        return 1
    end

    set title "$_flag_title"
    mkdir -p $dir

    if test -e $file
        echo "File already exists: $file"
    else
        printf "%s\n" \
            --- \
            "author: riou" \
            "title: $title" \
            "url: /posts/$today/" \
            "layout: post.ts" \
            "date: $today" \
            "type: post" \
            --- >$file
        echo "Created: $file"
    end

    $EDITOR $file
end
