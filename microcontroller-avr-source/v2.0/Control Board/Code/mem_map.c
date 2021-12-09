
unsigned long int data_pointers_addr[4];

unsigned char content_settings_caches[4][MAX_CONTENT_SETTINGS_SIZE];

//TDisplayStage Temp_ds;

void get_global_settings(TGlobalSettings *gs)
{
  mem_read_block(MEM_START_OFFSET, sizeof(TGlobalSettings), (unsigned char *) gs);
}

void Stages(unsigned char StageIndex /*starting from 0*/, TDisplayStage *Stage)
{
  unsigned long int addr;
  
  addr = MEM_START_OFFSET + (unsigned long) sizeof(TGlobalSettings) + (unsigned long) StageIndex * (unsigned long) sizeof(TDisplayStage);
  mem_read_block(addr, sizeof(TDisplayStage), (unsigned char *) Stage);
}

unsigned long int CalcStageTotalDataSize(unsigned char s_index, TDisplayStage *Temp_ds)
{
  unsigned long int StageDataSize = 0;
  unsigned char i;
  //TDisplayStage ThisStage;  --> Use Temp_ds instead
  
  //Stages(s_index, &ThisStage);
  Stages(s_index, Temp_ds);
  for(i = 0; i < 4; i++)
    if(Temp_ds->Areas[i].ContentType != 0)  //if not an unused area
      StageDataSize = StageDataSize + (unsigned long) Temp_ds->Areas[i].DataSize;
    //if(ThisStage.Areas[i].ContentType != 0)  //if not an unused area
    //  StageDataSize = StageDataSize + (unsigned long) ThisStage.Areas[i].DataSize;

  return(StageDataSize);
}

// --> Define the DataPointers function as a macro to speed up code execution
#define DataPointers(AreaIndex, offset) mem_read_cache(data_pointers_addr[AreaIndex] + offset)
/*
unsigned char DataPointers(unsigned char AreaIndex, unsigned long int offset)
{
  return(mem_read_cache(data_pointers_addr[AreaIndex] + offset));
}
*/

void DataPointersNoCache(unsigned char AreaIndex, unsigned long int offset, unsigned int size, unsigned char data[])
{
  mem_read_block(data_pointers_addr[AreaIndex] + offset, size, data);
}

void update_content_settings_caches()
{
  unsigned char dp_index;
  
  for(dp_index = 0; dp_index < 4; dp_index++)
  {
    DataPointersNoCache(dp_index, 0UL, MAX_CONTENT_SETTINGS_SIZE, content_settings_caches[dp_index]);
  }
}

void update_data_pointers(unsigned char s_index /*stage index*/, TDisplayStage *Temp_ds)
{
  unsigned long int stage_data_offset;
  //TDisplayStage ds;  --> Use Temp_ds instead
  unsigned char i;
  
  //Calc data offset of the new stage
  #pragma warn-
  stage_data_offset = MEM_START_OFFSET + (unsigned long) sizeof(TGlobalSettings) + (unsigned long) sizeof(TDisplayStage) * (unsigned long) StageCount;
  for(i = 0; i < s_index; i++)
    stage_data_offset = stage_data_offset + CalcStageTotalDataSize(i, Temp_ds);
  #pragma warn+
  
  data_pointers_addr[0] = stage_data_offset;
  //Stages(s_index, &ds);
  Stages(s_index, Temp_ds);
  for(i = 1; i < 4; i++)
    data_pointers_addr[i] = data_pointers_addr[i - 1] + (unsigned long) Temp_ds->Areas[i - 1].DataSize;
    //data_pointers_addr[i] = data_pointers_addr[i - 1] + (unsigned long) ds.Areas[i - 1].DataSize;
  
  update_content_settings_caches();
}

//-------------------------------------------------
void get_content_settings(unsigned char dp_index, unsigned char size, unsigned char *data)
{
  //unsigned char i;
  
  memcpy(data, content_settings_caches[dp_index], size);  //--> memcpt is used for more speed
  
  /*
  for(i = 0; i < size; i++)
  {
    data[i] = content_settings_caches[dp_index][i];
  }
  */
}

unsigned char fa_Data(unsigned char dp_index, unsigned long int offset)
{
  return(DataPointers(dp_index, (unsigned long) sizeof(TFramedAnimation) + offset));
}

unsigned char slst_Data(unsigned char dp_index, unsigned long int offset)
{
  return(DataPointers(dp_index, (unsigned long) sizeof(TSingleLineScrollingText) + offset));
}
