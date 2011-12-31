require 'spec_helper'

describe GameOfLifeBoard do
  
  before :each do
    @gol = GameOfLifeBoard.new("spec/test1.gol")
  end
  
  describe "#getNeighbors" do
    it "should give back the approriate number of neighbors" do
      n00 = @gol.getNeighbors 0, 0
      n00.should have(3).items

      n30 = @gol.getNeighbors 3, 0
      n30.should have(3).items

      n17 = @gol.getNeighbors 1, 7
      n17.should have(5).items

      n37 = @gol.getNeighbors 3, 7
      n37.should have(3).items

      n14 = @gol.getNeighbors 1, 4
      n14.should have(8).items
    end
  end
  
  describe "living neighbors" do
    it "should have certain amount of living neighbors" do
      living = lambda {|arr| arr.select { |cell| cell == GameOfLifeBoard::LIVE }}

      n00 = @gol.getNeighbors 0, 0
      living.call(n00).should have(0).items

      n30 = @gol.getNeighbors 3, 0
      living.call(n30).should have(0).items

      n17 = @gol.getNeighbors 1, 7
      living.call(n17).should have(0).items

      n23 = @gol.getNeighbors 2, 3
      living.call(n23).should have(2).items

      n14 = @gol.getNeighbors 1, 4
      living.call(n14).should have(2).items
    end
  end
  describe "#new" do
    it "should match the spec" do
      lines = File.readlines('spec/test1.gol').join.strip
      @gol.to_s.should == lines 
    end
  end

  describe "#nextGeneration!" do
    it "should match the follow up spec" do
      lines = File.readlines('spec/test2.gol').join.strip
      @gol.nextGeneration!
      @gol.to_s.should == lines
    end
  end

end
=begin
describe User do
  it "should be in any roles assigned to it" do
    user = User.new
    user.should be_in_role("assigned role")
  end
end
$ spec user_spec.rb --format specdoc
=end

