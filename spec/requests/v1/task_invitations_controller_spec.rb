require 'rails_helper'

describe V1::TaskInvitationsController, type: :request do
  let!(:user) { User.make! }

  describe "GET /task_invitations" do
    it "return all not accepted task_invitations of current user" do
      3.times { TaskInvitation.make! }
      3.times { TaskInvitation.make!(user: user, accepted: true) }
      2.times { TaskInvitation.make!(user: user) }
      get task_invitations_path, {}, basic_header(user.auth_token)
      expect(response.status).to eq 200
      expect(json.count).to eq(2)
    end
  end

  describe "POST /task_invitations" do
    context "with valid attributes" do
      it "should create a task_invitations for the user and task given" do
        task = Task.make!(:job)
        expect {
          post task_invitations_path, { user_id: user.id, task_id: task.id} , basic_header(user.auth_token)
        }.to change(TaskInvitation, :count).by(1)
        expect(response.status).to eq 201
        expect(TaskInvitation.last.user).to eq(user)
        expect(TaskInvitation.last.task).to eq(task)
        expect(TaskInvitation.last).to_not be_accepted

      end
    end
    context "with invalid attributes" do
      it "return the errors in format json" do
        expect {
          post task_invitations_path, { user_id: user.id  }, basic_header(user.auth_token)
        }.to change(Task, :count).by(0)
        expect(json).to eq({"task_id"=>["can't be blank"]})
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT /task_invitations/:id" do
    it "should update a task" do
      invitation = TaskInvitation.make!(user: user)
      put task_invitation_path(invitation), {}, basic_header(user.auth_token)
      expect(json["accepted"]).to eq(true)
    end
  end

  describe "DELETE /task_invitations/:id" do
    it "delete a task invitation" do
      invitation = TaskInvitation.make!(user: user)
      expect {
        delete task_invitation_path(invitation), {}, basic_header(user.auth_token)
      }.to change(TaskInvitation, :count).by(-1)
      expect(response.status).to eq 204
    end
  end
end