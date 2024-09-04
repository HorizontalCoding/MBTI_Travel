// 지역 코드에 따라 기본 이미지를 매핑
final Map<int, String> defaultImages =
{
  // 춘천시
  13: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%B6%98%EC%B2%9C%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 원주시
  9: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%9B%90%EC%A3%BC%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 강릉시
  1: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EA%B0%95%EB%A6%89%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 동해시
  3: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EB%8F%99%ED%95%B4%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 태백시
  14: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%ED%83%9C%EB%B0%B1%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 속초시
  5: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%86%8D%EC%B4%88%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 삼척시
  4: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%82%BC%EC%B2%99%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 양양군
  7: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%96%91%EC%96%91%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 홍천군
  16: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%ED%99%8D%EC%B2%9C%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 횡성군
  18: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%ED%9A%A1%EC%84%B1%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 영월군
  8: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%98%81%EC%9B%94%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 평창군
  15: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%ED%8F%89%EC%B0%BD%EC%8B%9C_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 정선군
  11: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%A0%95%EC%84%A0%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 철원군
  12: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%B2%A0%EC%9B%90%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 화천군
  17: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%ED%99%94%EC%B2%9C%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 양구군
  6: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%96%91%EA%B5%AC%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 인제군
  10: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EC%9D%B8%EC%A0%9C%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
  // 고성군
  2: 'https://mbti-travel-prod-bucket.s3.ap-northeast-2.amazonaws.com/Thumb_images/%EA%B3%A0%EC%84%B1%EA%B5%B0_%EC%8D%B8%EB%84%A4%EC%9D%BC.png',
};