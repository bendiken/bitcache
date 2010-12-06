require 'bitcache/spec'

share_as :Bitcache_Set do
  include Bitcache::Spec::Matchers

  before :each do
    raise '+@class+ must be defined in a before(:all) block' unless instance_variable_get(:@class)
    @id0 = Identifier.new("\x00" * 16)
    @id1 = Identifier.new("\x01" * 16)
    @id2 = Identifier.new("\x02" * 16)
    @set = @class.new([@id0, @id1, @id2])
  end

  describe "Set#clone" do
    it "returns a Set" do
      @set.clone.should be_a Set
    end

    it "returns an identical copy of the set" do
      @set.clone.to_a.should eql @set.to_a
    end
  end

  describe "Set#dup" do
    it "returns a Set" do
      @set.dup.should be_a Set
    end

    it "returns an identical copy of the set" do
      @set.dup.to_a.should eql @set.to_a
    end
  end

  describe "Set#empty?" do
    it "returns a Boolean" do
      @set.empty?.should be_a_boolean
    end

    it "returns true if the set is empty" do
      Set.new.should be_empty
    end

    it "returns false if the set is not empty" do
      Set.new([@id1]).should_not be_empty
    end
  end

  describe "Set#size" do
    it "returns an Integer" do
      @set.size.should be_an Integer
    end

    it "returns the cardinality of the set" do
      @set.size.should eql 3
    end

    it "returns zero if the set is empty" do
      Set.new.size.should be_zero
    end
  end

  describe "Set#insert" do
    it "inserts the given identifier into the set" do
      id = Identifier.new("\xff" * 16)
      @set.to_a.should_not include id
      @set.insert(id)
      @set.to_a.should include id
    end

    it "returns self" do
      @set.insert(@id0).should equal @set
    end
  end

  describe "Set#delete" do
    it "removes the given identifier from the set" do
      @set.to_a.should include @id0
      @set.delete(@id0)
      @set.to_a.should_not include @id0
    end

    it "returns self" do
      @set.delete(@id0).should equal @set
    end
  end

  describe "Set#to_set" do
    it "returns self" do
      @set.to_set.should equal @set
    end
  end

  describe "Set#to_a" do
    it "returns an Array" do
      @set.to_a.should be_an Array
    end

    it "returns an Array of equal cardinality" do
      @set.to_a.size.should eql @set.size
    end

    it "returns elements in lexical order" do
      # TODO
    end
  end
end
