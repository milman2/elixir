# OTP (Open Telecom Platform)
- Supervisor
- GenServer
- Application
- Task
- Registry
- DynamicSupervisor

```shell
mix new counter_app
cd counter_app

iex -S mix
```

```shell
mix new otp_counter --sup
cd otp_counter

iex -S mix
OtpCounter.Counter.get()     # => 0
OtpCounter.Counter.inc()
OtpCounter.Counter.get()     # => 1

OtpCounter.Counter.crash()   # 강제 종료

# 자동으로 Supervisor가 재시작
OtpCounter.Counter.get()     # => 0 (초기화됨)
```