#! /bin/sh

unset MINC_TOOLKIT
unset MINC_TOOLKIT_VERSION


if [[ ! -z ${PATH_MINC_TOOLKIT_SAVE} ]];then
export PATH=${PATH_MINC_TOOLKIT_SAVE}
fi

if [[ ! -z ${PERL5LIB_MINC_TOOLKIT_SAVE} ]];then
export PERL5LIB=${PERL5LIB_MINC_TOOLKIT_SAVE}
fi

if [[ ! -z ${ANTSPATH_SAVE} ]];then
export ANTSPATH=${ANTSPATH_SAVE}
else
unset ANTSPATH
fi

unset MNI_DATAPATH
unset MINC_FORCE_V2
unset MINC_COMPRESS
unset VOLUME_CACHE_THRESHOLD
