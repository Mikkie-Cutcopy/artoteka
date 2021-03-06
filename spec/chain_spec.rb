require 'chain'
require 'spec_helper'
require 'rails_helper'

RSpec.describe Chain do

  describe 'Without circle' do

    before(:context) do
      @chain = Chain::ChainObject.new([1, 'hello', :wounderful])
    end


    # [1, 'hello', :wounderful]
    it 'current link' do
      expect(@chain.current).to eq(1)
    end

    it 'next link' do
      @chain.next
      expect(@chain.current).to eq(1)
      @chain.next!
      expect(@chain.current).to eq('hello')

      @chain.to_end!
      @chain.next!
      expect(@chain.current).to eq(:wounderful)
    end

    it 'previous link' do
      @chain.previous!
      expect(@chain.current).to eq('hello')
      @chain.previous!
      expect(@chain.current).to eq(1)

      @chain.previous
      expect(@chain.current).to eq(1)
      @chain.previous!
      expect(@chain.current).to eq(1)
    end

  end

  describe 'With circle' do
    before(:context) do
      @chain = Chain::ChainObject.new([1, 'hello', :wounderful], circle: true)
    end

    it 'current link' do
      expect(@chain.current).to eq(1)
    end

    it 'next link' do
      @chain.next
      expect(@chain.current).to eq(1)
      @chain.next!
      expect(@chain.current).to eq('hello')

      @chain.to_end!
      @chain.next!
      expect(@chain.current).to eq(1)
    end

    it 'previous link' do
      @chain.previous!
      expect(@chain.current).to eq(:wounderful)
      @chain.previous!
      expect(@chain.current).to eq('hello')

      @chain.previous
      expect(@chain.current).to eq('hello')
      @chain.previous!
      expect(@chain.current).to eq(1)

      @chain.to_start!
      @chain.previous!
      expect(@chain.current).to eq(:wounderful)
    end

  end

  describe 'with set_to' do

    it 'current link' do
      @chain = Chain::ChainObject.new([1, 'hello', :wounderful], circle: true, set_to: 2)
      expect(@chain.current).to eq(:wounderful)
      expect(@chain.next!).to eq(1)
    end

    it 'current link set_to 0' do
      @chain = Chain::ChainObject.new([1, 'hello', :wounderful], circle: true, set_to: 0)
      expect(@chain.current).to eq(1)
    end

    it 'current link set_to 3' do
      @chain = Chain::ChainObject.new([1, 'hello', :wounderful], circle: true, set_to: 3)
      expect(@chain.current).to eq(1)
      expect(@chain.next!).to eq('hello')
    end

    it 'current link set_to 3' do
      @chain = Chain::ChainObject.new([1, 'hello', :wounderful], set_to: 4)
      expect(@chain.current).to eq('hello')
    end
  end

end