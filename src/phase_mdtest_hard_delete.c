#include <sys/stat.h>
#include <unistd.h>

#include <io500-phase.h>
#include <phase_mdtest.h>

typedef struct{
  opt_mdtest_generic g;
  mdtest_generic_res res;
} opt_mdtest_hard_delete;

static opt_mdtest_hard_delete o;

static ini_option_t option[] = {
  {"API", "The API to be used", 0, INI_STRING, NULL, & o.g.api},
  {"run", "Run this phase", 0, INI_BOOL, "TRUE", & o.g.run},
  {NULL} };


static void validate(void){

}

static double run(void){
  u_argv_t * argv = u_argv_create();
  mdtest_hard_add_params(argv);
  u_argv_push(argv, "-r");	/* only remove files */
  u_argv_push_printf(argv, "--saveRankPerformanceDetails=%s/mdtest-hard-delete.csv", opt.resdir);

  opt_mdtest_hard d = mdtest_hard_o;
  mdtest_add_generic_params(argv, & d.g, & o.g);

  if(opt.dry_run || o.g.run == 0 || mdtest_hard_o.g.run == 0){
    u_argv_free(argv);
    return 0;
  }

  FILE * out = u_res_file_prep(p_mdtest_hard_delete.name);
  p_mdtest_run(argv, out, & o.res, MDTEST_FILE_REMOVE_NUM);

  return o.res.rate;
}

u_phase_t p_mdtest_hard_delete = {
  "mdtest-hard-delete",
  IO500_PHASE_REMOVE,
  option,
  validate,
  run,
  0,
  .group = IO500_SCORE_MD
};
