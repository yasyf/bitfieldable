# frozen_string_literal: true

require 'bitfieldable'

describe Bitfieldable::Concern do
  let(:klass) do
    Class.new do
      include Bitfieldable::Concern

      bitfields flags: %i[foo bar baz]

      attr_accessor :flags

      def initialize
        self.flags = 0
      end
    end
  end

  subject(:instance) { klass.new }

  it 'initializes' do
    expect(subject.flags).to eq(0)
  end

  it 'defaults flags to false' do
    expect(subject.foo).to be(false)
    expect(subject.foo?).to be(false)
  end

  it 'can toggle flags' do
    subject.flip_foo!
    expect(subject.foo?).to be(true)
    subject.flip_foo!
    expect(subject.foo?).to be(false)
  end

  it 'can set flags to true' do
    subject.foo!
    expect(subject.foo?).to be(true)
  end

  it 'can set flags to false' do
    subject.foo = true
    expect(subject.foo?).to be(true)
    subject.foo = false
    expect(subject.foo?).to be(false)
  end

  it 'writes the correct bitfield' do
    subject.class.bitfield_spec.each do |flag, spec|
      subject.send("#{flag}!")
      expect(subject.flags).to eq(2**spec['index'])
      subject.send("flip_#{flag}!")
    end
  end
end
