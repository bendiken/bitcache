require 'bitcache/spec'

share_as :Bitcache_Block do
  include Bitcache::Spec::Matchers

  before :each do
    raise '+@class+ must be defined in a before(:all) block' unless instance_variable_get(:@class)
    @block = @class.new
  end

  describe "Block.new" do
    it "returns a new Block" do
      @class.new.should be_a @class
    end

    it "yields self if passed a block" do
      yielded = nil
      block = @class.new { |block| yielded = block }
      yielded.should be_a Block
      yielded.should equal block
    end
  end

  describe "Block#id" do
    it "returns an Identifier" do
      @block.id.should be_an Identifier
    end
  end

  describe "Block#size" do
    it "returns an Integer" do
      @block.size.should be_an Integer
    end
  end

  describe "Block#data" do
    it "returns an IO stream" do
      [IO, StringIO].should include @block.data.class
    end
  end

  describe "Block#empty?" do
    it "returns a Boolean" do
      @block.empty?.should be_a_boolean
    end
  end

  describe "Block#nonzero?" do
    it "returns a Boolean" do
      @block.nonzero?.should be_a_boolean
    end
  end

  describe "Block#zero?" do
    it "returns a Boolean" do
      @block.zero?.should be_a_boolean
    end
  end

  describe "Block#binary?" do
    it "returns a Boolean" do
      @block.binary?.should be_a_boolean
    end
  end

  describe "Block#ascii?" do
    it "returns a Boolean" do
      @block.ascii?.should be_a_boolean
    end
  end

  describe "Block#==" do
    it "returns a Boolean" do
      (@block == @block).should be_a_boolean
    end
  end

  describe "Block#eql?" do
    it "returns a Boolean" do
      @block.eql?(@block).should be_a_boolean
    end
  end

  describe "Block#hash" do
    it "returns a Fixnum" do
      @block.hash.should be_a Fixnum
    end
  end

  describe "Block#pos" do
    it "returns an Integer" do
      @block.pos.should be_an Integer
    end
  end

  describe "Block#rewind" do
    it "returns zero" do
      @block.rewind.should be_zero
    end
  end

  describe "Block#seek" do
    it "returns zero" do
      @block.seek(0, IO::SEEK_SET).should be_zero
    end
  end

  describe "Block#[]" do
    it "returns an Integer" do
      @block[0].should be_an Integer
    end
  end

  describe "Block#read" do
    it "returns a String" do
      @block.read(1).should be_a String
    end
  end

  describe "Block#readpartial" do
    it "returns a String" do
      @block.readpartial(1).should be_a String
    end
  end

  describe "Block#readbyte" do
    it "returns an Integer" do
      @block.readbyte.should be_an Integer
    end
  end

  describe "Block#readbytes" do
    it "returns a String" do
      @block.readbytes(1).should be_a String
    end
  end

  describe "Block#readchar" do
    it "returns a character" do
      @block.readchar.should be_a ?c.class # Ruby 1.8/1.9
    end
  end

  describe "Block#readline" do
    it "returns a String" do
      @block.readline.should be_a String
    end
  end

  describe "Block#readlines" do
    it "returns an Array" do
      @block.readlines.should be_an Array
    end
  end

  describe "Block#getbyte" do
    it "returns an Integer" do
      @block.getbyte.should be_an Integer
    end
  end

  describe "Block#getc" do
    it "returns a character" do
      @block.getc.should be_a ?c.class # Ruby 1.8/1.9
    end
  end

  describe "Block#gets" do
    it "returns a String" do
      @block.gets.should be_a String
    end
  end

  describe "Block#bytes" do
    it "returns an Enumerator" do
      @block.bytes.should be_an Enumerator
    end
  end

  describe "Block#chars" do
    it "returns an Enumerator" do
      @block.chars.should be_an Enumerator
    end
  end

  describe "Block#lines" do
    it "returns an Enumerator" do
      @block.lines.should be_an Enumerator
    end
  end

  describe "Block#lineno" do
    it "returns an Integer" do
      @block.lineno.should be_an Integer
    end
  end

  describe "Block#each_byte" do
    it "returns an Enumerator" do
      @block.each_byte.should be_an Enumerator
    end

    it "yields Integer bytes" do
      @block.each_byte do |byte|
        byte.should be_an Integer
      end
    end
  end

  describe "Block#each_char" do
    it "returns an Enumerator" do
      @block.each_char.should be_an Enumerator
    end

    it "yields characters" do
      @block.each_char do |char|
        char.should be_a ?c.class # Ruby 1.8/1.9
      end
    end
  end

  describe "Block#each_line" do
    it "returns an Enumerator" do
      @block.each_line.should be_an Enumerator
    end

    it "yields String lines" do
      @block.each_line do |line|
        line.should be_a String
      end
    end
  end

  describe "Block#unpack" do
    it "returns an Array" do
      @block.unpack('C').should be_an Array
    end
  end

  describe "Block#to_id" do
    it "returns an Identifier" do
      @block.to_id.should be_an Identifier
    end
  end

  describe "Block#to_io" do
    it "returns an IO stream" do
      [IO, StringIO].should include @block.to_io.class
    end
  end

  describe "Block#to_str" do
    it "returns a String" do
      @block.to_str.should be_a String
    end
  end

  describe "Block#to_s" do
    it "returns a String" do
      @block.to_s.should be_a String
    end
  end

  describe "Block#inspect" do
    it "returns a String" do
      @block.inspect.should be_a String
    end
  end
end
