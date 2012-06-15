MVMObject * MVM_file_get_anon_oshandle_type(MVMThreadContext *tc);
void MVM_file_copy(MVMThreadContext *tc, MVMString *src, MVMString *dest);
void MVM_file_delete(MVMThreadContext *tc, MVMString *f);
MVMint64 MVM_file_exists(MVMThreadContext *tc, MVMString *f);
MVMObject * MVM_file_open_fh(MVMThreadContext *tc, MVMObject *type_object, MVMString *filename, MVMint64 flag);
MVMString * MVM_file_read_fhs(MVMThreadContext *tc, MVMObject *oshandle, MVMint64 length);
MVMString * MVM_file_slurp(MVMThreadContext *tc, MVMString *filename);
char * MVM_file_get_full_path(MVMThreadContext *tc, apr_pool_t *tmp_pool, char *path);
MVMObject * MVM_file_get_stdin(MVMThreadContext *tc);
MVMObject * MVM_file_get_stdout(MVMThreadContext *tc);
MVMObject * MVM_file_get_stderr(MVMThreadContext *tc);