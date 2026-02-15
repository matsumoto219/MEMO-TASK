require "csv" #CSVファイルを扱うためのライブラリを読み込む

#変数定義
memo_type = nil

#1 or 2が入力されるまでwhileループ
while memo_type != 1 && memo_type != 2
  puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"
  memo_type = gets.to_i #ユーザーの入力値を取得し、数字へ変換

  if memo_type != 1 && memo_type != 2
    puts "不正な値です。1か2を入力してください。"
  end
end

#書き込み関数
def write_csv(file_path, memo_lines, mode)
  CSV.open(file_path, mode) do |csv|
    memo_lines.each do |line|
      next if line.strip.empty? #空行ならスキップ
      csv << [line]
    end
  end
end

#メモ作成関数
def create_memo
  puts "新規メモを作成します"
  puts "ファイル名を入力してください(例: memo)"

  file_name = gets.chomp #改行を取り除く
  file_name = file_name.sub(/\.csv\z/i, "") #拡張子重複防止

  if file_name.empty? #ファイル名が空かチェック
    puts "ファイル名が空です。処理を中断します。"
    return
  end
  file_path = "#{file_name}.csv"

  #内容入力受付(Ctrl + D で保存)
  puts "メモの内容を入力してください(Ctrl + D で保存)"
  memo_lines = STDIN.readlines.map(&:chomp) #Ctrl+Dまでの複数行を配列で受け取って改行を削除

  #CSVを作成し、書き込み
  write_csv(file_path, memo_lines, "w")
  puts "作成したファイル: #{file_path}"
end

#メモ編集関数
def edit_memo
  puts "既存メモを編集します"
  puts "編集したいファイル名を入力してください"

  file_name = gets.chomp
  file_name = file_name.sub(/\.csv\z/i, "") #拡張子重複防止
  file_path = "#{file_name}.csv"

  #ファイルが存在するか確認
  unless File.exist?(file_path)
    puts "指定されたファイルが存在しません: #{file_path}"
    return
  end

  puts "保存方法を選んでください"
  puts "1 → 上書きする / 2 → 追記する"
  mode_choice = gets.to_i

  if mode_choice == 1
    mode = "w"
  elsif mode_choice == 2
    mode = "a"
  else
    puts "不正な値です。上書きで保存します。"
    mode = "w"
  end

  #内容入力受付(Ctrl + D で保存)
  puts "メモの内容を入力してください(Ctrl + D で保存)"
  memo_lines = STDIN.readlines.map(&:chomp) #Ctrl+Dまでの複数行を配列で受け取って改行を削除

  write_csv(file_path, memo_lines, mode)
  puts "編集したファイル: #{file_path}"
end

if memo_type == 1
  create_memo
elsif memo_type == 2
  edit_memo
end