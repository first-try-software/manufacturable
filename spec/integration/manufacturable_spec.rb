RSpec.describe 'Manufacturable' do
  describe 'trying to build a class before registering anything' do
    it 'returns nil' do
      expect(Manufacturable.build(Object, :anything)).to be_nil
    end
  end

  describe 'building a class registered on the Object namespace' do
    let!(:sedan) { Class.new { extend Manufacturable::Item; corresponds_to :four_door } }

    it 'returns an instance of Sedan' do
      expect(Manufacturable.build(Object, :four_door)).to be_a_kind_of(sedan)
    end
  end

  describe 'building a class registered on the namespace of an explicit superclass' do
    let(:automobile) { Class.new { extend Manufacturable::Item } }
    let!(:sedan) { Class.new(automobile) { corresponds_to :four_door } }

    it 'returns an instance of Sedan' do
      expect(Manufacturable.build(automobile, :four_door)).to be_a_kind_of(sedan)
    end
  end

  describe 'building a default manufacturable' do
    let(:automobile) { Class.new { extend Manufacturable::Item } }
    let!(:sedan) { Class.new(automobile) { default_manufacturable } }

    it 'returns an instance of Sedan' do
      expect(Manufacturable.build(automobile, :unknown_key)).to be_a_kind_of(sedan)
    end
  end

  describe 'building a class with named params' do
    let(:automobile) { Class.new { extend Manufacturable::Item; def initialize(color:); end } }
    let!(:sedan) { Class.new(automobile) { corresponds_to :sedan } }

    around do |example|
      original_stderror = $stderr
      $stderr = StringIO.new
      example.run
      $stderr = original_stderror
    end

    it 'does not warn' do
      Manufacturable.build_one(automobile, :sedan, color: 'blue')

      expect($stderr.string).to be_empty
    end
  end

  describe 'building multiple classes registered with the same key' do
    let(:component) { Class.new { extend Manufacturable::Item } }
    let!(:engine) { Class.new(component) { corresponds_to :sedan } }
    let!(:transmission) { Class.new(component) { corresponds_to :sedan } }

    it 'returns an instance of Sedan' do
      expect(Manufacturable.build(component, :sedan))
        .to match_array([a_kind_of(engine), a_kind_of(transmission)])
    end
  end

  describe 'building a class that corresponds to all keys in a namespace' do
    let(:component) { Class.new { extend Manufacturable::Item } }
    let!(:standard_engine) { Class.new(component) { corresponds_to :sedan } }
    let!(:performance_engine) { Class.new(component) { corresponds_to :coupe } }
    let!(:transmission) { Class.new(component) { corresponds_to_all } }

    it 'returns an instance of Sedan' do
      expect(Manufacturable.build(component, :sedan))
        .to match_array([a_kind_of(standard_engine), a_kind_of(transmission)])
      expect(Manufacturable.build(component, :coupe))
        .to match_array([a_kind_of(performance_engine), a_kind_of(transmission)])
    end
  end
end
