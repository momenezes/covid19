#!/bin/sh

PATH=/home/mario/bin:/home/mario/.local/bin:/home/mario/bin:/home/mario/.local/bin:/home/mario/bin:/home/mario/.local/bin:/home/mario/bin:/home/mario/.local/bin:/home/mario/bin:/home/mario/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/usr/lib/rstudio-server/bin/pandoc
R_LIBS_SITE=/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library
RMARKDOWN_MATHJAX_PATH=/usr/lib/rstudio-server/resources/mathjax-26
R_PACKRAT_SYSTEM_LIBRARY=/usr/lib/R/library
R_PAPERSIZE_USER=letter
R_STRIP_STATIC_LIB=strip --strip-debug
R_UNZIPCMD=/usr/bin/unzip
R_BZIPCMD=/bin/bzip2
R_HOME=/usr/lib/R
R_PLATFORM=x86_64-pc-linux-gnu
R_LIBS_USER=~/R/x86_64-pc-linux-gnu-library/3.6
R_DOC_DIR=/usr/share/R/doc
R_SESSION_TMPDIR=/tmp/Rtmp6331z4
RSTUDIO_CONSOLE_COLOR=256
R_PACKRAT_SITE_LIBRARY=/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library
RSTUDIO_PANDOC=/usr/lib/rstudio-server/bin/pandoc
R_STRIP_SHARED_LIB=strip --strip-unneeded
R_PDFVIEWER=/usr/bin/xdg-open
R_INCLUDE_DIR=/usr/share/R/include

COVID="/home/mario/docs/analytics/covid19"
export COVID

cd ${COVID}

export PATH R_LIBS_SITE RMARKDOWN_MATHJAX_PATH R_PACKRAT_SYSTEM_LIBRARY R_LIBS_USER R_PACKRAT_SITE_LIBRARY RSTUDIO_PANDOC R_STRIP_SHARED_LIB R_INCLUDE_DIR

status=$?

R -e "rmarkdown::render('dataprep.Rmd',output_file='dataprep.html')" && R -e "rmarkdown::render('boletim.Rmd', output_file='boletim.html')"

if [ $? -eq 0 ] 
then
  R -e "rmarkdown::render('AnalysisExplorationsGraphics.Rmd', output_file='AnalysisExplorationsGraphics.html')"
  if [ $? -eq 0 ]
    then
      printf "Deu tudo certo com os markdowns\n"
      git add ${COVID}/dataprep.html ${COVID}/AnalysisExplorationsGraphics.html ${COVID}/boletim.html ${COVID}/data/eeuucovid19_last.csv ${COVID}/data/jhucovid19_last.csv ${COVID}/data/brazil_covid19.csv ${COVID}/data/caso_full.csv
      git commit -m "Cron script execution"
      git push 
      exit 0
  else
      printf "Deu ruim; código de erro %d\n", $? 
      exit 1
  fi
else
    printf "Deu ruim dataprep.Rmd; código de erro %d\n", $?
    exit 1
fi

