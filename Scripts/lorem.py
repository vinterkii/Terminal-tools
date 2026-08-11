#!/usr/bin/env python3

# Imported modules
import sys
import random

# Words used to generate the lorem text

words = [
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
        "a", "ac", "accumsan", "ad", "aenean", "aliquam", "aliquet", "ante",
        "aptent", "arcu", "at", "auctor", "augue", "bibendum", "blandit",
        "class", "commodo", "condimentum", "congue", "consequat", "conubia",
        "convallis", "cras", "cubilia", "curabitur", "curae", "cursus",
        "dapibus", "diam", "dictum", "dictumst", "dignissim", "dis", "donec",
        "dui", "duis", "efficitur", "egestas", "eget", "eleifend", "elementum",
        "enim", "erat", "eros", "est", "et", "etiam", "eu", "euismod", "ex",
        "facilisi", "facilisis", "fames", "faucibus", "felis", "fermentum",
        "feugiat", "finibus", "fringilla", "fusce", "gravida", "habitant",
        "habitasse", "hac", "hendrerit", "himenaeos", "iaculis", "id",
        "imperdiet", "in", "inceptos", "integer", "interdum", "justo",
        "lacinia", "lacus", "laoreet", "lectus", "leo", "libero", "ligula",
        "litora", "lobortis", "luctus", "maecenas", "magna", "magnis",
        "malesuada", "massa", "mattis", "mauris", "maximus", "metus", "mi",
        "molestie", "mollis", "montes", "morbi", "mus", "nam", "nascetur",
        "natoque", "nec", "neque", "netus", "nibh", "nisi", "nisl", "non",
        "nostra", "nulla", "nullam", "nunc", "odio", "orci", "ornare",
        "parturient", "pellentesque", "penatibus", "per", "pharetra",
        "phasellus", "placerat", "platea", "porta", "porttitor", "posuere",
        "potenti", "praesent", "pretium", "primis", "proin", "pulvinar",
        "purus", "quam", "quis", "quisque", "rhoncus", "ridiculus", "risus",
        "rutrum", "sagittis", "sapien", "scelerisque", "sed", "sem", "semper",
        "senectus", "sociosqu", "sodales", "sollicitudin", "suscipit",
        "suspendisse", "taciti", "tellus", "tempor", "tempus", "tincidunt",
        "torquent", "tortor", "tristique", "turpis", "ullamcorper", "ultrices",
        "ultricies", "urna", "ut", "varius", "vehicula", "vel", "velit",
        "venenatis", "vestibulum", "vitae", "vivamus", "viverra", "volutpat",
        "vulputate"
    ]

# check if an argument is passed
if len(sys.argv) >= 2 :
    arg = int(sys.argv[1])
    auto = True
else :
    auto = False

# functions
def lorem_auto(length) :
    i = 0
    while i < length :
        print("[" + str(i) + "]" + " hello")
        i += 1
    print("Done")

def lorem_manual() :
        print("1")

if auto == True :
    lorem_auto(arg)
elif auto == False :
    lorem_manual()
else :
    print("The F*ck did you do?!")
    
print("end")














import random
from typing import List, Literal


class Lorem:

    @staticmethod
    def word() -> str:
        """Generate a random Lorem Ipsum word."""
        return random.choice(Lorem._WORDS)

    @staticmethod
    def words(num: int = 1) -> str:
        """Generate a string of random Lorem Ipsum words.
        
        Args:
            num: Number of words to generate (default: 1)
            
        Returns:
            String of random words
        """
        if num <= 0:
            return ""

        words = [Lorem.word() for _ in range(num)]
        return " ".join(words)

    @staticmethod
    def sentence(word_count: int = None) -> str:
        """Generate a random Lorem Ipsum sentence.
        
        Args:
            word_count: Number of words in the sentence (default: random between 3 and 15)
            
        Returns:
            A capitalized sentence ending with a period
        """
        if word_count is None:
            word_count = random.randint(3, 15)

        sentence = Lorem.words(word_count)
        return sentence[0].upper() + sentence[1:] + "."

    @staticmethod
    def sentences(num: int = 1) -> str:
        """Generate random Lorem Ipsum sentences.
        
        Args:
            num: Number of sentences (default: 1)
            
        Returns:
            String containing sentences
        """
        if num <= 0:
            return ""

        sentences = [Lorem.sentence() for _ in range(num)]
        return " ".join(sentences)

    @staticmethod
    def paragraph(sentence_count: int = None) -> str:
        """Generate a random Lorem Ipsum paragraph.
        
        Args:
            sentence_count: Number of sentences in paragraph (default: random between 3 and 7)
            
        Returns:
            A paragraph of text
        """
        if sentence_count is None:
            sentence_count = random.randint(3, 7)

        return Lorem.sentences(sentence_count)

    @staticmethod
    def paragraphs(num: int = 1, separator: str = "\n\n") -> str:
        """Generate random Lorem Ipsum paragraphs.
        
        Args:
            num: Number of paragraphs (default: 1)
            separator: String to separate paragraphs (default: two newlines)
            
        Returns:
            String containing paragraphs
        """
        if num <= 0:
            return ""

        paragraphs = [Lorem.paragraph() for _ in range(num)]
        return separator.join(paragraphs)


class LoremIpsum:
    """
    LoremIpsum class

    Provides methods to generate Lorem Ipsum text in different formats and lengths.
    """

    def __init__(self, words: List[str] = None):
        """
        Initializes the LoremIpsum generator with a standard set of Lorem Ipsum words

        Args:
            words: Optional custom list of words to use instead of the default Lorem Ipsum words
        """
        if words is not None:
            self.words = words
        else:
            self.words = [
                'lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
                'adipiscing', 'elit', 'sed', 'do', 'eiusmod', 'tempor',
                'incididunt', 'ut', 'labore', 'et', 'dolore', 'magna',
                'aliqua', 'enim', 'ad', 'minim', 'veniam', 'quis',
                'nostrud', 'exercitation', 'ullamco', 'laboris', 'nisi',
                'aliquip', 'ex', 'ea', 'commodo', 'consequat', 'duis',
                'aute', 'irure', 'dolor', 'in', 'reprehenderit', 'voluptate',
                'velit', 'esse', 'cillum', 'dolore', 'fugiat', 'nulla',
                'pariatur', 'excepteur', 'sint', 'occaecat', 'cupidatat',
                'non', 'proident', 'sunt', 'culpa', 'qui', 'officia',
                'deserunt', 'mollit', 'anim', 'id', 'est', 'laborum'
            ]

    def generateWords(self, count: int = 10, capitalize: bool = False) -> str:
        """
        Generate Lorem Ipsum text with specified number of words

        Randomly selects words from the internal word list to create a string
        of space-separated words.

        Args:
            count: Number of words to generate (default: 10)
            capitalize: Whether to capitalize the first letter of each word (default: False)

        Returns:
            Generated Lorem Ipsum text as a string of words
        """
        if count <= 0 or not self.words:
            return ""

        result = []
        for _ in range(count):
            # Select a random word from the words list
            word = random.choice(self.words)

            # Capitalize the word if requested
            if capitalize:
                word = word[0].upper() + word[1:]

            result.append(word)

        return " ".join(result)

    def generateBytes(self, bytes_count: int = 100) -> str:
        """
        Generate Lorem Ipsum text with specified number of bytes

        Creates text that is approximately the requested size in bytes.
        This is useful when you need text of a specific size for testing.

        Args:
            bytes_count: Approximate number of bytes to generate (default: 100)

        Returns:
            Generated Lorem Ipsum text with the requested byte size
        """
        if bytes_count <= 0 or not self.words:
            return ""

        result = ""
        # Add words until we exceed the desired byte length
        while len(result.encode('utf-8')) < bytes_count:
            result += self.generateWords(1) + " "

        # Trim characters until we're under the desired byte length
        while len(result.encode('utf-8')) > bytes_count and result:
            result = result[:-1]

        return result.strip()

    def generateSentences(self, count: int = 3) -> str:
        """
        Generate Lorem Ipsum text with specified number of sentences

        Creates properly formatted sentences with capitalization and periods.
        Each sentence contains a random number of words (between 5-15).

        Args:
            count: Number of sentences to generate (default: 3)

        Returns:
            Generated Lorem Ipsum text as a string of sentences
        """
        if count <= 0 or not self.words:
            return ""

        result = []
        for _ in range(count):
            # Generate a random number of words for this sentence
            words_count = random.randint(5, 15)  # 5-15 words per sentence
            sentence = self.generateWords(words_count)
            # Capitalize first letter and add period
            if sentence:
                result.append(sentence[0].upper() + sentence[1:] + ".")

        return " ".join(result)

    def generateParagraphs(self, count: int = 1, withLineBreaks: bool = True) -> str:
        """
        Generate Lorem Ipsum text with specified number of paragraphs

        Creates paragraphs containing multiple sentences. Each paragraph has
        a random number of sentences (between 3-6).

        Args:
            count: Number of paragraphs to generate (default: 1)
            withLineBreaks: Whether to separate paragraphs with newlines (default: True)

        Returns:
            Generated Lorem Ipsum text as a string of paragraphs
        """
        if count <= 0 or not self.words:
            return ""

        result = []
        for _ in range(count):
            # Generate a random number of sentences for this paragraph
            sentence_count = random.randint(3, 6)  # 3-6 sentences per paragraph
            paragraph = self.generateSentences(sentence_count)
            if paragraph:
                result.append(paragraph)

        # Join paragraphs with line breaks or spaces depending on parameter
        return "\n\n".join(result) if withLineBreaks else " ".join(result)

    def generateList(self, count: int = 5, style: Literal['bullet', 'number', 'none'] = 'bullet') -> str:
        """
        Generate Lorem Ipsum text as a list

        Creates a list of items with optional formatting (bullet points or numbers).
        Each list item contains a random number of words (between 3-8).

        Args:
            count: Number of list items (default: 5)
            style: List style: 'bullet' for bullet points, 'number' for numbered list, 'none' for plain text (default: 'bullet')

        Returns:
            Generated Lorem Ipsum list as a newline-separated string
        """
        if count <= 0 or not self.words:
            return ""

        items = []
        for i in range(count):
            # Generate a random number of words for this list item
            words_count = random.randint(3, 8)  # 3-8 words per item
            text = self.generateWords(words_count)

            if not text:
                continue

            # Apply the appropriate list style prefix
            if style == 'bullet':
                prefix = '• '
            elif style == 'number':
                prefix = f"{i + 1}. "
            else:  # 'none' or any other value
                prefix = ''

            # Capitalize first letter of each list item
            items.append(prefix + text[0].upper() + text[1:])

        return "\n".join(items)


# Create a singleton instance of the LoremIpsum class
loremIpsum = LoremIpsum()
