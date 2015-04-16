require 'test_helper'
# rubocop:disable ClassLength
class MemesControllerTest < ActionController::TestCase
  let(:meme) do
    FactoryGirl.build(:meme).tap { |m| m.stubs(:id).returns(1) }
  end

  let(:memes) do
    [meme]
  end

  let(:meme_params) do
    {
      meme: {
        picture: FactoryGirl.meme_attachment('meme.jpg'),
        tags: 'category1, category2'
      }
    }.with_indifferent_access
  end

  def assert_html(_response)
  end

  def assert_json(response)
    JSON.parse(response.body)
  end

  def expects_strong_params
    MemesController::MemeParams.expects(:build)
      .with(has_key('meme'))
      .returns(meme_params[:meme])
  end

  describe 'on getting index' do
    before do
      Meme.expects(:order).with(created_at: :desc)
        .returns(memes)
    end

    def ensure_index(format, params)
      yield if block_given?
      get :index, params.merge(format: format)
      response.status.must_equal 200
      assigns(:memes).wont_be_nil
      assert_template :index
      send("assert_#{format}", response)
    end

    with_request_formats do |format|
      it 'returns all items' do
        ensure_index(format, {})
      end

      it 'filters the items using tags' do
        ensure_index(format, q: 'category1, category2') do
          memes.expects(:all_tags).with(%w(category1 category2))
            .returns(memes)
        end
      end
    end
  end

  it 'gets new' do
    get :new
    assigns(:meme).must_be_instance_of Meme
    assert_template :new
  end

  describe 'on posting create' do
    def assert_html_success(_response)
      assert_redirected_to memes_path
    end

    def assert_html_failure(response)
      response.status.must_equal 200
      assert_template :new
    end

    def assert_json_success(response)
      response.status.must_equal 201
      assert_json(response)
      assert_template :show
    end

    def assert_json_failure(response)
      response.status.must_equal 422
      assert_json(response)
    end

    with_request_formats do |format|
      with_result_states('create') do |result, message|
        it "#{message} a meme" do
          expects_strong_params
          Meme.any_instance.expects(:save).returns(result == :success)
          post :create, meme_params.merge(format: format)
          assigns(:meme).wont_be_nil
          send("assert_#{format}_#{result}", response)
        end
      end
    end
  end

  describe 'setting a meme' do
    def ensure_response
      response.status.must_equal 200
      assigns(:meme).must_equal meme
    end

    before do
      Meme.expects(:find).with('1').returns(meme)
    end

    with_request_formats do |format|
      it 'shows the meme' do
        get :show, id: 1, format: format
        ensure_response
        assert_template :show
        send("assert_#{format}", response)
      end

      def assert_html_success(_response)
        assert_redirected_to memes_path
      end

      describe 'on putting update' do
        def assert_html_failure(response)
          response.status.must_equal 200
          assert_template :edit
        end

        def assert_json_success(response)
          response.status.must_equal 200
          assert_json(response)
          assert_template :show
        end

        def assert_json_failure(response)
          response.status.must_equal 422
          assert_json(response)
        end

        with_result_states('update') do |result, message|
          it "#{message} the meme" do
            expects_strong_params
            meme.expects(:update).with(has_key('picture'))
              .returns(result == :success)
            put :update, meme_params.merge(format: format, id: 1)
            assigns(:meme).wont_be_nil
            send("assert_#{format}_#{result}", response)
          end
        end
      end

      describe 'on deleting with destroy' do
        def assert_json_success(_response)
          assert_redirected_to memes_path
        end

        it 'destroys the meme' do
          meme.expects :destroy
          delete :destroy, id: 1
          send("assert_#{format}_success", response)
        end
      end
    end

    it 'edits the meme' do
      get :edit, id: 1
      ensure_response
      assert_template :edit
    end
  end
end

describe MemesController::MemeParams do
  let(:meme_params) { MemesController::MemeParams }

  it 'normalizes the tags' do
    meme_params.normalize_tags(' category1   , category2 ')
      .must_equal %w(category1 category2)
  end

  it 'creates and empty tag list' do
    meme_params.normalize_tags(nil).must_equal []
  end

  it 'cleans the params' do
    params = { meme: { foo: 'bar', picture: '(ಠ_ಠ)_%', tags: '1, 2' } }
    params = ActionController::Parameters.new(params)
    meme_params.build(params)
      .must_equal('picture' => '(ಠ_ಠ)_%', 'tags' => %w(1 2))
  end
end
