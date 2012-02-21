%solve_pdat_set  run solver on a pdat structure array

function slv_set = solve_pdat_set(pdat_set,options,varargin)
  
  in_parse = inputParser();
  in_parse.KeepUnmatched = true;
  in_parse.addParamValue('solve_inactive',0,@(x) x==0 || x==1 || islogical(x));
  in_parse.addParamValue('print_flag',0,@(x) x==0 || x==1 || islogical(x));
  in_parse.addParamValue('out_dir','',@(x) ischar(x));
  in_parse.addParamValue('out_iter',0,@(x) x==0 || x==1 || islogical(x));
  in_parse.addParamValue('slvmax',0,@(x) x>=0);

  in_parse.parse(varargin{:});
  s = in_parse.Results;
  
  if nargin == 0
    slv_set = s;
    return;
  end
  
  % initial ouput
  if s.print_flag
    fprintf('\n... mcute_test_pdat_set start ...\n\n');
  end
  
  if ~isempty(s.out_dir) && ~exist(s.out_dir,'file')
    % create output dir if it does not exist
    mkdir(s.out_dir);
  end
  
  if s.out_dir
    % make sure s.out_dir ends with a '/'
    if s.out_dir(end) ~= '/'
      s.out_dir = [s.out_dir '/'];
    end
  end

  % print output dir
  if s.print_flag
    fprintf('options:\n');
    fprintf('  solve_inactive.. %d\n',s.solve_inactive);
    fprintf('  print_flag...... %d\n',s.print_flag);
    fprintf('  out_dir......... %s\n',s.out_dir);
    fprintf('  out_iter........ %d\n',s.out_iter);
    fprintf('  slvmax.......... %d\n\n',s.slvmax);
  end
  
  % get number of problems
  pdat_num = length(pdat_set);
  
  slvcnt = 0;
  failcnt = 0;
  for i = 1:pdat_num
    
    if pdat_set(i).isactive || s.solve_inactive
    
      %set io options
      io_opt.print_flag = s.print_flag;
      io_opt.iter_fname = sprintf('%s%03d-%s.txt',s.out_dir,slvcnt,pdat_set(i).problem);

      % increment solve counter
      slvcnt = slvcnt + 1;

      slv_set(slvcnt) = solve_pdat(pdat_set(i),options,io_opt);
      
      if slv_set(slvcnt).info ~= 1
        failcnt = failcnt + 1;
      end
      
    end

    if s.slvmax && slvcnt >= s.slvmax
      break
    end
    
  end
  
  % orient the output
  slv_set = slv_set(:);

  % final ouput
  if s.print_flag
    fprintf('\nresults:\n')
    fprintf('  solve attempts.. %d\n',slvcnt);
    fprintf('  failures........ %d\n',failcnt);
    fprintf('\n... solve_pdat_set end ...\n');
  end
  
end