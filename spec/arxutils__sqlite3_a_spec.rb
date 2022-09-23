RSpec.describe Arxutils_Sqlite3_a do
  it "raise" do
    ret = nil
    expect { ret.puts }.to raise_error(StandardError)
  end
end
