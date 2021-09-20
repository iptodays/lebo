/*
 * @Author: iptoday 
 * @Date: 2021-09-20 12:13:34 
 * @Last Modified by: iptoday
 * @Last Modified time: 2021-09-20 12:20:05
 */
class LBLelinkProgressInfo {
  /// 当前播放进度位置，单位秒
  late final int currentTime;

  /// 总时长，单位秒
  late final int duration;

  LBLelinkProgressInfo({
    required int duration,
    required int currentTime,
  });

  LBLelinkProgressInfo.fromJson(Map<String, dynamic> json) {
    currentTime = json['currentTime'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['currentTime'] = this.currentTime;
    json['duration'] = this.duration;
    return json;
  }
}
