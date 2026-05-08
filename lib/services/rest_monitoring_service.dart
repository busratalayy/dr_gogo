class RestMonitoringService {
  static String getRestStatus(double motionLevel) {
    if (motionLevel < 1.05) {
      return "Resting";
    } else if (motionLevel < 1.30) {
      return "Low Activity";
    } else {
      return "Active";
    }
  }

  static String getMovementLevel(double motionLevel) {
    if (motionLevel < 1.05) {
      return "Very Low";
    } else if (motionLevel < 1.30) {
      return "Low";
    } else {
      return "Moderate";
    }
  }

  static String getRestSummary(double motionLevel) {
    if (motionLevel < 1.05) {
      return "Your pet is currently in a calm resting state.";
    } else if (motionLevel < 1.30) {
      return "Your pet shows low movement and may be relaxing.";
    } else {
      return "Your pet is currently active.";
    }
  }
}