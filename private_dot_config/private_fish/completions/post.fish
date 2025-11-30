set -l posts_dir ~/build/github.com/riou0801/riou0801.github.io/src/posts
set -l today (date '+%Y-%m-%d.md')

# --title オプション補完
complete -c post -l title -s t -d "Title of the post"

# 今日の日付のファイルと既存ファイルを補完候補として提示
# 重複は自動的に除去される
complete -c post -f -a "(echo $today; test -d $posts_dir && basename -a (ls $posts_dir/*.md 2>/dev/null) | sort -r)" -d "Post file"
