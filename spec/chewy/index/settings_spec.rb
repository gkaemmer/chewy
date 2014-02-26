require 'spec_helper'

describe Chewy::Index::Settings do
  include ClassHelpers

  describe '#resolve_dependencies' do
    let(:repository) { Chewy::Repository.new(:foo).set(:baaaz, {baaaz: :baaaz}).set(:dependency_a, {a: :a}).set(:dependency_b, {b: :b}) }

    context 'when :foo defined as a hash' do
      let(:params) { {analyzer: {bar: {foo: :dependency_a}, baz: {foo: :dependency_b}}, foo: {baaaz: 'baaaz'}} }

      it 'appends dependencies' do
        dependencies = {baaaz: 'baaaz', dependency_a: {a: :a}, dependency_b: {b: :b}}
        subject.inject_dependencies(:foo, params, repository)[:foo].should == dependencies
      end
    end

    context 'when :foo undefined' do
      let(:params) { {analyzer: {bar: {foo: :dependency_a}, baz: {foo: :dependency_b}}} }

      it 'creates hash with dependencies' do
        dependencies = {dependency_a: {a: :a}, dependency_b: {b: :b}}
        subject.inject_dependencies(:foo, params, repository)[:foo].should == dependencies
      end
    end

    context 'when :foo defined as an array' do
      let(:params) { {analyzer: {bar: {foo: :dependency_a}, baz: {foo: :dependency_b}}, foo: [:baaaz]} }

      it 'creates hash with dependencies' do
        dependencies = {dependency_a: {a: :a}, dependency_b: {b: :b}, baaaz: {baaaz: :baaaz}}
        subject.inject_dependencies(:foo, params, repository)[:foo].should == dependencies
      end
    end

    context 'when analyzer undefined' do
      let(:params) { {} }

      it 'do not raise any error' do
        expect { subject.inject_dependencies(:foo, params, repository)[:foo] }.to_not raise_error
      end
    end
  end
end