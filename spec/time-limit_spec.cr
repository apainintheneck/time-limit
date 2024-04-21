require "./spec_helper"

describe TimeLimit do
  context "when it completes in time" do
    it "returns the result of the block" do
      TimeLimit.spawn(1.second) do
        5 * 6
      end.should eq 30
    end

    it "returns the result of the block using next" do
      TimeLimit.spawn(1.second) do
        next 11 * 12
      end.should eq 132
    end

    it "returns nil if the block is empty" do
      TimeLimit.spawn(1.second) { }.should eq nil
    end
  end

  context "when the block raises an exception" do
    it "re-raises the exception" do
      expect_raises(DivisionByZeroError) do
        TimeLimit.spawn(1.second) do
          100 // 0
        end
      end
    end

    it "re-raises the exception when the block returns NoReturn" do
      expect_raises(ArgumentError) do
        TimeLimit.spawn(1.second) do
          raise ArgumentError.new
        end
      end
    end
  end

  context "when it times out" do
    it "raise a timeout exception" do
      expect_raises(TimeLimit::TimeoutException) do
        TimeLimit.spawn(1.second) do
          sleep 2.seconds
        end
      end
    end
  end
end
