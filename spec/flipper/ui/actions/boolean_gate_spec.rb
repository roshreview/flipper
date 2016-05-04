require 'helper'

RSpec.describe Flipper::UI::Actions::BooleanGate do
  describe "POST /features/:feature/boolean" do
    context "with enable" do

      shared_examples_for "successful enable" do |feature|
        it "enables the feature" do
          expect(flipper.enabled?(feature.to_sym)).to be(true)
        end

        it "redirects back to feature" do
          expect(last_response.status).to be(302)
          expect(last_response.headers["Location"]).to eq("/features/#{feature}")
        end
      end

      before do
        flipper.disable :search
        post "features/search/boolean",
          {"action" => "Enable", "authenticity_token" => "a"},
          "rack.session" => {"_csrf_token" => "a"}
      end

      it_behaves_like "successful enable", "search"

      context "with spaced feature name" do
        before do
          flipper.disable :search
          post "features/search%20bar/boolean",
            {"action" => "Enable", "authenticity_token" => "a"},
            "rack.session" => {"_csrf_token" => "a"}
        end

        it_behaves_like "successful enable", "search bar"
        # need more testing here. shared_example_group may be giving a false positive

      end
    end

    context "with disable" do
      before do
        flipper.enable :search
        post "features/search/boolean",
          {"action" => "Disable", "authenticity_token" => "a"},
          "rack.session" => {"_csrf_token" => "a"}
      end

      it "disables the feature" do
        expect(flipper.enabled?(:search)).to be(false)
      end

      it "redirects back to feature" do
        expect(last_response.status).to be(302)
        expect(last_response.headers["Location"]).to eq("/features/search")
      end
    end
  end
end
