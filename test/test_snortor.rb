# encoding: UTF-8
require 'test/unit'
require_relative "helper"

class SnortorTest < Test::Unit::TestCase
  def delete_out_directory
    out = File.join(BASE_DIR,"test","out")
    FileUtils.rm_rf(out) if Dir.exists?(out)
  end

  def test_import_rules
    Snortor.import_rules(FIXTURES_DIR)
    assert_equal 6, Snortor.rules.size
    assert !Snortor.rules[4].active

    assert_equal Snortor.rules.find_all_by_msg("BAD-TRAFFIC").size, 2
    assert Snortor.rules.find_by_msg("BAD-TRAFFIC")

    assert_equal Snortor.rules.find_all_by_msg("Command Execution").size, 2
    assert Snortor.rules.find_by_msg("Command Execution")

    assert_equal Snortor.rules.find_all_by_msg("TFTP GET filename overflow").size, 0


    delete_out_directory
    Snortor.rules[0].active = false
    Snortor.export_rules(File.join(BASE_DIR,"test","out"))

    Snortor.import_rules(File.join(BASE_DIR,"test","out"))
    assert_equal 6, Snortor.rules.size
    assert !Snortor.rules[0].active
    assert Snortor.rules[1].active
    assert Snortor.rules[2].active
    assert Snortor.rules[3].active
    assert !Snortor.rules[4].active
  end

  def test_ruleset
    a = Snortor::Rulefile.new(File.join(FIXTURES_DIR,"ruleset1.rules"))

    a << Snort::Rule.new({})
    assert_raise ArgumentError do
      a << Snortor::Rulefile.new #error
    end
    assert_raise Errno::ENOENT do
      a << Snortor::Rulefile.new("path")
    end
  end


  def test_ruleset_collection
    a = Snortor::RulefileCollection.new

    rf1 = Snortor::Rulefile.new(File.join(FIXTURES_DIR,"ruleset1.rules"))
    r1 = Snort::Rule.new({})
    r2 = Snort::Rule.new({})
    r3 = Snort::Rule.new({})
    r4 = Snort::Rule.new({})
    r5 = Snort::Rule.new({})

    rf1 << r1
    rf1 << r2
    rf1 << r3

    rf2 = Snortor::Rulefile.new(File.join(FIXTURES_DIR,"ruleset2.rules"))
    rf2 << r4
    rf2 << r5

    a << rf1
    a << rf2

    assert_equal 5, a.size

    assert_equal r1, a[0]
    assert_equal r2, a[1]
    assert_equal r3, a[2]
    assert_equal r4, a[3]
    assert_equal r5, a[4]
  end

  def test_set_deactivated_rule_active
    Snortor.import_rules(FIXTURES_DIR)
    assert_equal 6, Snortor.rules.size
    Snortor.rules.each do |rule|
      rule.active = true
    end
    Snortor.export_rules(File.join(BASE_DIR,"test","out"))
  end
end
