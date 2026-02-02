#include <iostream>
#include <random>
#include <string>
#include <unordered_set>
#include <vector>

int main() {
    const std::vector<std::string> answers = {
        "It is certain.",
        "It is decidedly so.",
        "Without a doubt.",
        "Yes - definitely.",
        "You may rely on it.",
        "As I see it, yes.",
        "Most likely.",
        "Outlook good.",
        "Yes.",
        "Signs point to yes.",
        "Reply hazy, try again.",
        "Ask again later.",
        "Better not tell you now.",
        "Cannot predict now.",
        "Concentrate and ask again.",
        "Don't count on it.",
        "My reply is no.",
        "My sources say no.",
        "Outlook not so good.",
        "Very doubtful."
    };

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dist(0, answers.size()-1);

    std::unordered_set<std::string> askedQuestions;
    std::string line;

    while (true) {
        std::cout << "Ask your question: " << std::flush;
        if (!std::getline(std::cin, line))
            break;

        if (line.empty())
            break;

        if (askedQuestions.contains(line))
            std::cout << "Your question has already been answered\n";
        else {
            std::string answer = answers[dist(gen)];
            std::cout << answer << "\n";
            askedQuestions.insert(std::move(line));
        }
    }
}
