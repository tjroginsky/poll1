json.extract! question, :id, :text, :answerA, :answerB, :created_at, :updated_at
json.url question_url(question, format: :json)
