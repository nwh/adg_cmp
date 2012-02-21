%adg_test_problems  test cuter problems

function adg_test_problems
  
  pdat_set = mcute_org2pdat('adg_set.org');
  pdat_test = mcute_test_pdat_set(pdat_set,1,1);
  mcute_struct2org(pdat_test,'adg_test.org');
  
  %keyboard
  
end