append_path() { local arr; arr=( ${(s,:,P)1} ); arr[(r)$2]=(); arr=( $arr $2 ); : ${(P)1::=${(j,:,)arr}} }
prepend_path() { local arr; arr=( ${(s,:,P)1} ); arr=( $2 $arr ); typeset -U arr; : ${(P)1::=${(j,:,)arr}} }
remove_path() { local arr; arr=( ${(s,:,P)1} ); arr[(r)$2]=();  : ${(P)1::=${(j,:,)arr}} }
