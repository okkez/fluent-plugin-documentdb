require 'helper'

class DocumentdbOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    docdb_endpoint DOCUMENTDB_ACCOUNT_ENDPOINT
    docdb_account_key DOCUMENTDB_ACCOUNT_KEY
    docdb_database mydb
    docdb_collection mycollection
    localtime true
    time_format %Y%m%d-%H:%M:%S
    add_time_field true
    time_field_name time
    add_tag_field true
    tag_field_name tag
  ]
  # CONFIG = %[
  #   path #{TMP_DIR}/out_file_test
  #   compress gz
  #   utc
  # ]

  def create_driver(conf = CONFIG, tag='documentdb.test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::DocumentdbOutput, tag).configure(conf)
  end

  def test_configure
    #### set configurations
    # d = create_driver %[
    #   path test_path
    #   compress gz
    # ]
    #### check configurations
    # assert_equal 'test_path', d.instance.path
    # assert_equal :gz, d.instance.compress
  end

  def test_format
    d = create_driver

    # time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    # d.emit({"a"=>1}, time)
    # d.emit({"a"=>2}, time)

    # d.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":1}\n]
    # d.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":2}\n]

    # d.run
  end

  def test_write
    d = create_driver

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.emit({"a"=>1}, time)
    d.emit({"a"=>2}, time)
    data = d.run
    puts data
    # ### FileOutput#write returns path
    # path = d.run
    # expect_path = "#{TMP_DIR}/out_file_test._0.log.gz"
    # assert_equal expect_path, path
  end
end

