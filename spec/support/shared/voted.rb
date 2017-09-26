shared_examples_for 'voted' do
  let(:resource) { controller.controller_name.singularize.to_sym }
  let(:voted) { create(resource) }

  describe 'PATCH #vote_up' do
    context 'Authorized user votes up for the resource' do
      user_sign_in

      it 'adds positive vote to the resource' do
        expect { patch :vote_up, params: { id: voted, format: :json } }.to change(voted.votes, :count).by(1)
      end

      it 'updates current rating of the resource' do
        patch :vote_up, params: { id: voted, format: :json }
        voted.reload
        expect(voted.rating).to eq 1
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'Authorized user votes down for the resource' do
      user_sign_in

      it 'adds negative vote to the resource' do
        expect { patch :vote_down, params: { id: voted, format: :json } }.to change(voted.votes, :count).by(1)
      end

      it 'updates current rating of the resource' do
        patch :vote_down, params: { id: voted, format: :json }
        voted.reload
        expect(voted.rating).to eq -1
      end
    end
  end

  describe 'PATCH #revote' do
    context 'Authorized user revotes for the resource' do
      user_sign_in

      it 'deletes vote of the user from resource votes' do
        patch :vote_up, params: { id: voted, format: :json }
        patch :revote, params: { id: voted, format: :json }
        voted.reload
        expect(voted.rating).to eq 0
      end
    end
  end

  describe 'Checking cases' do
    context 'Authorized user tries to vote for his own resource' do
      user_sign_in
      let(:user_voted) { create(resource, user: @user) }

      it 'does not add positive vote to the resource' do
        expect { patch :vote_up, params: { id: user_voted, format: :json } }.to_not change(user_voted.votes, :count)
      end
    end

    context 'Authorized user tries to vote twice' do
      user_sign_in

      it 'changes amount of the votes once' do
        patch :vote_up, params: { id: voted, format: :json }
        expect { patch :vote_up, params: { id: voted, format: :json } }.to_not change(voted.votes, :count)
        expect(response).to have_http_status(422)
      end
    end
  end
end