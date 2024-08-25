defmodule LiveviewMentalMathGameWeb.GameLive do
  use LiveviewMentalMathGameWeb, :live_view

  @mathQuestions [{"2 + 3", 5}, {"2 * 3", 6}, {"2 - 3", -1}]

  defp assign_random_question(socket) do
    {question, answer} = Enum.random(@mathQuestions)

    assign(socket, question: question, answer: answer)
  end

  def render(assigns) do
    ~H"""
    <h1>Score: <%= @score %></h1>
    <h1>Question: <%= @question %></h1>
    <.simple_form id="math-form" for={@form} phx-submit="answer">
      <.input name="answer" label="test" value="" type="number" />
      <:actions>
        <.button>Submit</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign_random_question(socket) |> assign(score: 0, form: to_form(%{}))}
  end

  def handle_event("answer", params, socket) do
    with {given_answer, _rest} <- Integer.parse(params["answer"]) do
      correct? = given_answer === socket.assigns.answer

      socket =
        if correct? do
          assign_random_question(socket)
          |> assign(score: socket.assigns.score + 1)
          |> put_flash(:info, "Correct!")
        else
          socket |> put_flash(:error, "Wrong answer!")
        end

      {:noreply, socket}
    else
      :error -> {:noreply, socket |> put_flash(:error, "Unknown error!")}
    end
  end
end
