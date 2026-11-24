"""Tìm ứng viên bằng TF-IDF và không gian ngữ nghĩa tiềm ẩn (LSA) cục bộ."""
import re

import numpy as np
from sklearn.decomposition import TruncatedSVD
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import normalize

from .policy import EXAMPLES, STOP, norm


ALIASES = {
    "duong mau": "duong huyet", "glucose mau": "duong huyet",
    "tut duong": "ha duong", "mon an": "thuc pham", "an quan": "nha hang",
    "tap luyen": "van dong", "the duc": "van dong", "loi rang": "nuou",
    "stress": "cang thang", "a1c": "hba1c", "tieu duong": "dai thao duong",
}


def canonical(text):
    value = norm(text)
    for phrase, replacement in ALIASES.items():
        value = re.sub(r"\b" + phrase + r"\b", replacement, value)
    return value


class PassageIndex:
    def __init__(self, facts):
        self.ids = [f["id"] for f in facts]
        self.topics = [f["topic"] for f in facts]
        documents = [f["concept"] + " " + f["concept"] + " " + f["text"] for f in facts]
        examples = [q for group in EXAMPLES.values() for q in group]
        self.vectorizer = TfidfVectorizer(preprocessor=canonical, stop_words=sorted(STOP),
                                          ngram_range=(1, 2), sublinear_tf=True)
        matrix = self.vectorizer.fit_transform(documents + examples)
        self.lexical = matrix[:len(facts)]
        self.svd = TruncatedSVD(n_components=min(32, matrix.shape[1]-1), random_state=27)
        self.semantic = normalize(self.svd.fit_transform(matrix)[:len(facts)])

    def rank(self, question, facts, policy, previous=""):
        clauses = [p.strip() for p in re.split(r"[?;,]|\bvà\b|\bcòn\b", question, flags=re.I) if p.strip()]
        queries = [question] + (clauses[:6] if len(clauses)>1 else [])
        if previous:
            queries = [q+" "+previous for q in queries]
        vectors = self.vectorizer.transform(queries)
        lexical = (vectors @ self.lexical.T).toarray()
        semantic = normalize(self.svd.transform(vectors)) @ self.semantic.T
        scores = 0.7*lexical + 0.3*np.maximum(0,semantic)
        available = {f["id"]:f for f in facts}
        candidates = []
        for row, query in enumerate(queries):
            priors = dict(policy.rank(query))
            # A topic preference breaks ties. Every passage remains searchable.
            scores[row] += [min(1,priors.get(t,0))*0.055 for t in self.topics]
            ordered = np.argsort(-scores[row], kind="stable")
            ranked = [self.ids[i] for i in ordered if self.ids[i] in available and lexical[row,i]>0
                      and scores[row,i]>=0.10]
            candidates.append(ranked)
        selected = []
        for group in candidates[1:]:
            selected.extend(group[:2])
        selected.extend(candidates[0])
        return [available[i] for i in dict.fromkeys(selected)][:9]
