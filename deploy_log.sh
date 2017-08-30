# jenkins 배포할 때 관련 정보를 log로 남기는 shell script
# 에러가 발생해도 현재 job에 영향을 주지 않도록 블럭 처리
{
# 커밋 메시지와 종료시각 수집
COMMIT_MESSAGE=$(git log -1 --pretty=format:"%s(committer:%cn)" ${GIT_COMMIT} | cat)
END_TIMESTAMP=$(date +'%Y%m%d%H%M%S')
  
# 수집 정보 전송(5초 이상 지연되면 전송 포기) by 승원님
# 전송 내용 : project_name(젠킨스 프로젝트 이름), build_url(젠킨스 위치 정보), git_url(소스 저장소 주소), start_timestamp(시작시각)
#           end_timestamp(종료시각), git_commit(커밋 메시지)
  curl -X POST \
  https://0yqhefhxb1.execute-api.ap-northeast-2.amazonaws.com/v1/recordapi \
  -H 'content-type: application/json; charset=utf-8' \
  -vs --max-time 5 \
  -d "{ \"project_name\": \"$JOB_BASE_NAME\",\"build_url\": \"$RUN_DISPLAY_URL\",\"git_url\": \"$GIT_URL\",\"start_timestamp\": \"$START_TIMESTAMP\",\"end_timestamp\": \"$END_TIMESTAMP\",\"git_commit\": \"$COMMIT_MESSAGE\"}"
  
 echo "deploy-record succeed"
} || {
  
   echo "An error has occurred. But build will continue"
      
}
# 전송 성공여부에 상관없이 성공 처리
true
