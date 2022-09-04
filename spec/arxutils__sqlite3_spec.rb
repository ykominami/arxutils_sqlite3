# frozen_string_literal: true

RSpec.describe Arxutils_Sqlite3 do
  it "has a version number" do
    expect(Arxutils_Sqlite3::VERSION).not_to be_nil
  end

  it "makemigrate makeconfig" do
    makeconfig = true
    remigrate = false
    ret = Makemigratex.migrate(makeconfig, remigrate)
    expect(ret).to be_nil
  end

  it "makemigrate remigrate" do
    makeconfig = false
    remigrate = true
    ret = Makemigratex.migrate(makeconfig, remigrate)
    expect(ret).to be_nil
  end

  it "makemigrate makeconfig remigrate" do
    makeconfig = true
    remigrate = true
    ret = Makemigratex.migrate(makeconfig, remigrate)
    expect(ret).to be_nil
  end

  it "makemigrate not specified" do
    makeconfig = false
    remigrate = false

    ret = Makemigratex.migrate(makeconfig, remigrate)
    expect(ret).to be_nil
  end
end
