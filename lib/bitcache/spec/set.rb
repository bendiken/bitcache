require 'bitcache/spec'

share_as :Bitcache_Set do
  include Bitcache::Spec::Matchers

  before :each do
    raise '+@class+ must be defined in a before(:all) block' unless instance_variable_get(:@class)
    @id0 = Bitcache::Identifier.new("\x00" * 16)
    @id1 = Bitcache::Identifier.new("\x01" * 16)
    @id2 = Bitcache::Identifier.new("\x02" * 16)
    @set = @class.new([@id0, @id1, @id2])
  end

  describe "Set[]" do
    it "returns a Set" do
      @class[@id0, @id1, @id2].should be_a @class
    end
  end

  describe "Set#clone" do
    it "returns a Set" do
      @set.clone.should be_a @class
    end

    it "returns an identical copy of the set" do
      @set.clone.to_a.should eql @set.to_a
    end
  end

  describe "Set#dup" do
    it "returns a Set" do
      @set.dup.should be_a @class
    end

    it "returns an identical copy of the set" do
      @set.dup.to_a.should eql @set.to_a
    end
  end

  describe "Set#freeze" do
    it "freezes the set" do
      @set.should_not be_frozen
      @set.freeze
      @set.should be_frozen
    end

    it "returns self" do
      @set.freeze.should equal @set
    end
  end

  describe "Set#empty?" do
    it "returns a Boolean" do
      @set.empty?.should be_a_boolean
    end

    it "returns true if the set contains no elements" do
      @class[].should be_empty
    end

    it "returns false if the set contains any elements" do
      @class[@id1].should_not be_empty
    end
  end

  describe "Set#cardinality" do
    it "returns an Integer" do
      @set.cardinality.should be_an Integer
    end

    it "returns the number of elements in the set" do
      @set.cardinality.should eql 3
    end

    it "returns zero if the set contains no elements" do
      @class[].cardinality.should be_zero
    end
  end

  describe "Set#count" do
    it "returns an Integer" do
      @set.count.should be_an Integer
    end

    it "returns the cardinality of the set" do
      @set.count.should eql 3
    end
  end

  describe "Set#count(id)" do
    it "returns an Integer" do
      @set.count(@id1).should be_an Integer
    end

    it "returns 1 if the set contains the identifier" do
      @set.count(@id1).should eql 1
    end

    it "returns 0 if the set doesn't contain the identifier" do
      @set.count(@id0.fill(0xff)).should eql 0
    end
  end

  describe "Set#count(&block)" do
    it "returns an Integer" do
      @set.count { |id| }.should be_an Integer
    end

    it "returns the number of matching identifiers" do
      @set.count { |id| }.should be_zero
      @set.count { |id| id == @id1 }.should eql 1
    end
  end

  describe "Set#has_identifier?" do
    it "returns a Boolean" do
      @set.has_identifier?(@id0).should be_a_boolean
    end

    it "returns true if the set contains the identifier" do
      @set.should include @id1
    end

    it "returns false if the set doesn't contain the identifier" do
      @set.should_not include @id0.dup.fill(0xff)
    end
  end

  describe "Set#each_identifier" do
    it "returns an Enumerator" do
      @set.each_identifier.should be_an Enumerator
    end

    it "yields each identifier in the set" do
      @set.each_identifier.to_a.should eql [@id0, @id1, @id2]
    end

    it "yields identifiers in lexical order" do
      # TODO
    end
  end

  describe "Set#==" do
    it "returns a Boolean" do
      (@set == @set).should be_a_boolean
    end

    it "returns true if the sets are the same object" do
      @set.should == @set
    end

    it "returns true if the sets are both empty" do
      set1, set2 = @class[], @class[]
      set1.should == set2
    end

    it "returns true if the sets are equal" do
      set1, set2 = @class[@id1, @id2], @class[@id2, @id1, @id1]
      set1.should == set2
    end

    it "returns false if the sets are not equal" do
      set1, set2 = @class[@id1, @id2], @class[@id2]
      set1.should_not == set2
    end
  end

  describe "Set#eql?" do
    it "returns a Boolean" do
      @set.eql?(@set).should be_a_boolean
    end

    it "returns true if the sets are the same object" do
      @set.should eql @set
    end

    it "returns true if the sets are both empty" do
      set1, set2 = @class[], @class[]
      set1.should eql set2
    end

    it "returns true if the sets are equal" do
      set1, set2 = @class[@id1, @id2], @class[@id2, @id1, @id1]
      set1.should eql set2
    end

    it "returns false if the sets are not equal" do
      set1, set2 = @class[@id1, @id2], @class[@id2]
      set1.should_not eql set2
    end
  end

  describe "Set#hash" do
    it "returns a Fixnum" do
      @set.hash.should be_a Fixnum
    end

    #it "returns the same hash code for equal sets" do
    #  @class[@id1].hash.should eql @class[@id1].hash
    #end
  end

  describe "Set#insert" do
    it "raises a TypeError if the set is frozen" do
      lambda { @set.freeze.insert(@id0) }.should raise_error TypeError
    end

    it "inserts the given identifier into the set" do
      id = @id0.fill(0xff)
      @set.should_not include id
      @set.insert(id)
      @set.should include id
    end

    it "returns self" do
      @set.insert(@id0).should equal @set
    end
  end

  describe "Set#delete" do
    it "raises a TypeError if the set is frozen" do
      lambda { @set.freeze.delete(@id0) }.should raise_error TypeError
    end

    it "removes the given identifier from the set" do
      @set.should include @id0
      @set.delete(@id0)
      @set.should_not include @id0
    end

    it "returns self" do
      @set.delete(@id0).should equal @set
    end
  end

  describe "Set#clear" do
    it "raises a TypeError if the set is frozen" do
      lambda { @set.freeze.clear }.should raise_error TypeError
    end

    it "removes all elements from the set" do
      @set.should_not be_empty
      @set.clear
      @set.should be_empty
    end

    it "returns self" do
      @set.clear.should equal @set
    end
  end

  describe "Set#merge" do
    it "returns a new Set" do
      @set.merge(@class[]).should be_a @class
      @set.merge(@class[]).should_not equal @set
    end

    it "returns a new Set containing all identifiers from both sets" do
      @class[@id1].merge(@class[@id2]).should eql @class[@id1, @id2]
    end
  end

  describe "Set#merge!" do
    it "raises a TypeError if the set is frozen" do
      lambda { @set.freeze.merge!(@class[]) }.should raise_error TypeError
    end

    it "merges in all identifiers from the other set" do
      @class[@id1].merge!(@class[@id2]).should eql @class[@id1, @id2]
    end

    it "returns self" do
      @set.merge!(@class[]).should equal @set
    end
  end

  describe "Set#to_set" do
    it "returns self" do
      @set.to_set.should equal @set
    end
  end

  describe "Set#to_list" do
    it "returns a List" do
      @set.to_list.should be_a List
    end

    it "returns a List of equal length to the cardinality of the set" do
      @set.to_list.length.should eql @set.cardinality
    end

    it "inserts all set elements into the list" do
      list = @set.to_list
      list.should include @id0, @id1, @id2
    end

    it "returns elements in lexical order" do
      # TODO
    end
  end

  describe "Set#to_filter" do
    it "returns a Filter" do
      @set.to_filter.should be_a Filter
    end

    it "returns a Filter of equal capacity to the cardinality of the set" do
      @set.to_filter.capacity.should eql @set.cardinality
    end

    it "inserts all set elements into the filter" do
      filter = @set.to_filter
      filter.should include @id0, @id1, @id2
    end
  end

  describe "Set#to_a" do
    it "returns an Array" do
      @set.to_a.should be_an Array
    end

    it "returns an Array of equal length to the cardinality of the set" do
      @set.to_a.length.should eql @set.cardinality
    end

    it "inserts all set elements into the array" do
      array = @set.to_a
      array.should include @id0, @id1, @id2
    end

    it "returns elements in lexical order" do
      # TODO
    end
  end

  describe "Set#inspect" do
    it "returns a String" do
      @set.inspect.should be_a String
    end
  end
end
