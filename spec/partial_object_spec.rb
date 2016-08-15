require 'spec_helper'

describe PartialObject do
  class RequiredParameter
    include PartialObject
    required_parameter :parameter_name

    def execute
      parameter_name
    end
  end

  describe RequiredParameter do
    it 'remembers the arguments passed in the constructor' do
      object = RequiredParameter
        .new(:parameter_name => "argument")

      expect(object.execute).to eq("argument")
    end

    it 'raises when the required parameter is not passed' do
      incomplete_object = RequiredParameter.new
      expect{incomplete_object.execute}.to raise_error ArgumentError, "the argument parameter_name is required"
    end

    it 'passing a nil argument is correct' do
      object = RequiredParameter
        .new(:parameter_name => nil)

      expect(object.execute).to eq(nil)
    end

    it 'remembers the arguments passed in partial' do
      object = RequiredParameter
        .new
        .partial(:parameter_name => "argument")

      expect(object.execute).to eq("argument")
    end

    it 'arguments passed in a partial supersede the constructor ones' do
      object = RequiredParameter
        .new(:parameter_name => "old argument")
        .partial(:parameter_name => "new argument")

      expect(object.execute).to eq("new argument")
    end

    it 'arguments passed in a later partial supersede old ones' do
      object = RequiredParameter
        .new
        .partial(:parameter_name => "old argument")
        .partial(:parameter_name => "new argument")

      expect(object.execute).to eq("new argument")
    end

    it 'does not forget old arguments' do
      old_object = RequiredParameter
        .new(:parameter_name => "old argument")
      new_object = old_object
        .partial(:parameter_name => "new argument")

      expect(old_object.execute).to eq("old argument")
    end

    it 'the argument can be accessed publicly' do
      object = RequiredParameter
        .new(:parameter_name => "argument")

      expect(object.parameter_name).to eq("argument")
    end
  end

  class OptionalParameter
    include PartialObject
    optional_parameter :parameter_name

    def execute
      parameter_name
    end
  end

  describe OptionalParameter do
    it 'remembers the arguments passed in the constructor' do
      object = OptionalParameter
        .new(:parameter_name => "argument")

      expect(object.execute).to eq("argument")
    end

    it 'returns nil for missing arguments' do
      incomplete_object = OptionalParameter
        .new

      expect(incomplete_object.execute).to eq(nil)
    end
  end

  class Person
    include PartialObject
    required_parameter :name, :last_name
    optional_parameter :language, :email

    def hey
      text = "Hey #{name} #{last_name}!"
      text += "\nI will contact you via #{email} in #{language || 'english'}" if email
      text
    end
  end

  it 'complex example 1' do
    person = Person
      .new(:name => "James", :last_name => "Doe")
      .partial(:name => "John", :email => "john@doe.com")

    expect(person.hey).to eq("Hey John Doe!\nI will contact you via john@doe.com in english")
  end

  it 'complex example 2' do
    person = Person
      .new(:last_name => "D.")
      .partial(:language => "french")
      .partial(:name => "J.")

    expect(person.hey).to eq("Hey J. D.!")
  end
end
