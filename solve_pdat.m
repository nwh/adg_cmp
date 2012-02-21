%solve_pdat  solve a cuter problem specified in a pdat struct
%
% Usage:
%   slv = solve_pdat(pdat,options,io_opt)
%
% Input:
%   pdat = problem specification structure
%   options = solver options structure
%   io_opt = input/output options structure
%
% io_opt fields:
%   print_flag = 1 for simple print to screen, 0 ow
%   iter_fname = file name for iter output from solver
%   dbg_fname = file name for debug output from solver
%
% Output:
%   slv = output structure from solver
%

function slv = solve_pdat(pdat,options,varargin)

  in_parse = inputParser();
  in_parse.KeepUnmatched = true;
  in_parse.addParamValue('print_flag',0,@(x) x==0 || x==1 || islogical(x));
  in_parse.addParamValue('iter_fname','',@(x) ischar(x));
  in_parse.parse(varargin{:});
  s = in_parse.Results;
  
  if nargin == 0
    slv = s;
    return;
  end
  
  % open files for output if needed
  if s.iter_fname
    options.print_file = fopen(s.iter_fname,'w');
  end
  
  % initial print
  if s.print_flag
    fprintf('solve_pdat: %8s  ',pdat.problem);
  end
  
  % build the problem
  [prob flag msg] = mcute_build(pdat);
  
  if ~flag
    error('solve_pdat:build_fail','mcute_build reported a failure.')
  end
  
  % get initial data
  %[usrf usrh x0 xlow xupp] = mcute_init(prob);
  [usrf usrh x0 bl bu A cl cu] = mcute_init(prob);

  % attempt to solve
  slvr = arcopt_nm_lc(usrf,usrh,x0,bl,bu,[],[],[],options);
  [xstar fstar info slv] = slvr.solve();

  % add a bit more info to slv
  slv.problem = pdat.problem;
  slv.param = pdat.param;
  slv.nvar = length(x0);
  slv.info = info;
  
  % final print
  if s.print_flag
    fprintf('%d\n',info);
  end

  % close output files
  if s.iter_fname
    fclose(options.print_file);
  end
  
  % clean the directory
  mcute_clean;
  
end