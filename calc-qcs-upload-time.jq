[ 
  .log.entries[] | 
    select(.request.url|contains("/api/v1/temp-contents/files/")) | 
    {
      fileId: .request.url |split("/") | reverse | .[0],
      size: .request.headers[] | select(.name == "content-length").value | tonumber,
      time: .time,
      t: .timings
    } 
] | 
group_by(.fileId) |
map({
  fileId: first.fileId,
  uploadSizeBytes: (
    reduce(.[]) as $i (0; . += ($i.size))
  ),
  uploadDurationSeconds: (
    (
      reduce(.[]) as $i (0; . += ($i.t.send))
    ) / 1000.0
  )
}) |
map(
  . + { 
    uploadSpeedMbps: (
      (.uploadSizeBytes) / (.uploadDurationSeconds) / pow(2; 17)
    )
  }
)
