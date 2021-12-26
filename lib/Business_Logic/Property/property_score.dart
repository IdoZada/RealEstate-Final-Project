class PropertyScore {
  static double _maxScore = 0;
  static double _minScore = 0;
  static int maxStars = 9; // for 1 to 10

  static const overallQualFactor = 1000; // overallQual 1-10 -- > max 10,000
  static const grLivAreaFactor = 10; // typ 1000 -- > max 10,000
  static getAllScores(List<Map<String, dynamic>> propertiesDetils) {
    for (var property in propertiesDetils) {
      double score = 0;
      score += double.parse(property['predictSalePrice']) -
          double.parse(property['SalePrice']);

      score += double.parse(property['OverallQual']) * overallQualFactor;
      score += double.parse(property['GrLivArea']) * grLivAreaFactor;
      // score += double.parse(property[''])

      property['score'] = score;
      updateMinMaxScore(property);
    }

    return propertiesDetils;
  }

  static getAllStars(List<Map<String, dynamic>> propertiesDetils) {
    for (var property in propertiesDetils) {
      normalizeScore(property);
    }
  }

  static void updateMinMaxScore(property) {
    if (property['score'] > _maxScore) _maxScore = property['score'];
    if (property['score'] < _minScore) _minScore = property['score'];
  }

  static normalizeScore(property) {
    // score between 1-10
    // zi = ((xi – min(x)) / (max(x) – min(x)) * Q) + 1.
    property['stars'] =
        (((property['score'] - _minScore) / (_maxScore - _minScore)) *
                maxStars) +
            1;
  }
}
