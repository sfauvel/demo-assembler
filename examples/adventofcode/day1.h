
int calibration(const char* line);
int calibration_from_file(const char* filename);
int calibration_from_buffer(const char* buffer);


int calibration_from_file_timer(const char* line, long* timer);
int calibration_from_buffer_timer(const char* line, long* timer);